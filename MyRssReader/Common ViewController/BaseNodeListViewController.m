//
//  BaseNodeListViewController.m
//  MyRssReader
//
//  Created by GEM on 6/15/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "BaseNodeListViewController.h"
#import "Node.h"
#import <UIImageView+AFNetworking.h>
#import "NodeListCustomCell.h"
#import "WebViewViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <XCDYouTubeVideoPlayerViewController.h>
#import <DMPlayerViewController.h>
#import <PureLayout.h>
#import <AFNetworking.h>
#import <AFDownloadRequestOperation.h>
#import <MBProgressHUD.h>
#import "DownloadManager.h"
#import "NSString+HTML.h"
#import "RPNodeDescriptionViewController.h"
#import "FileListViewController.h"
#import "NodeListViewController.h"

@interface BaseNodeListViewController ()<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, NodeListCustomCellDelegate>
{
    MPMoviePlayerViewController *moviePlayer;
    NSInteger willDownloadAtIndex;
    RssManager *manager;
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation BaseNodeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINib *nib = [UINib nibWithNibName:[self cellIdentifier] bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:[self cellIdentifier]];
    [self.searchDisplayController.searchResultsTableView registerNib:nib forCellReuseIdentifier:[self cellIdentifier]];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _interstitial = [self createAndLoadInterstital];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:kNotificationDownloadOperationStarted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:kNotificationDownloadOperationCompleted object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  should override methods
 *
 */
-(NSString *) cellIdentifier
{
    return NSStringFromClass([NodeListCustomCell class]);
}

-(ConfigureTableViewCellBlock) configureCellBlock
{
    return nil;
}

-(void) reloadTableView
{
    [self.tableView reloadData];
}

#pragma mark tableview delegate and datasource

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return _nodeList.count;
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RssNodeModel *node = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        node = searchResults[indexPath.row];
    } else {
        node = _nodeList[indexPath.row];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier] forIndexPath:indexPath];
    if ([self configureCellBlock]) {
        ConfigureTableViewCellBlock configureCellBlock = [self configureCellBlock];
        configureCellBlock(cell, node);
    }
    if ([cell respondsToSelector:@selector(setDelegate:)]) {
        [(NodeListCustomCell *)cell setDelegate:self];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    currentNode = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        currentNode = searchResults[indexPath.row];
    } else {
        currentNode = _nodeList[indexPath.row];
    }
    
    switch ([Common typeOfNode:currentNode.nodeType]) {
        case NODE_TYPE_RSS:
        {
            /**
             *  parse rss/xml
             */
            [self continueAtCurrentPath];
        }
            break;
        case NODE_TYPE_WEB_CONTENT:
        {
            [self continueAtCurrentPath];
        }
            break;
        default:
        {
            [self preLoadInterstitial];
        }
            break;
    }
}

#pragma mark continueAtCurrentPath after present interstital ads
-(void) continueAtCurrentPath
{
    /**
     *  check if node url is empty or not
     */
    if (!currentNode.nodeUrl || currentNode.nodeUrl.length <= 0) {
        
        RPNodeDescriptionViewController *viewcontroller = [Storyboard instantiateViewControllerWithIdentifier:@"RPNodeDescriptionViewController"];
        [viewcontroller setTitle:currentNode.nodeTitle];
        [viewcontroller setDesc:currentNode.nodeDesc];
        [viewcontroller setUrl:currentNode.nodeLink];
        [self.navigationController pushViewController:viewcontroller animated:YES];
        return;
    }
    /**
     *  otherwise
     */
    switch ([Common typeOfNode:currentNode.nodeType]) {
        case NODE_TYPE_RSS:
        {
            /**
             *  retrieve the cached RSS
             */
            Rss *cachedRss = [Rss MR_findFirstByAttribute:@"rssLink" withValue:currentNode.nodeUrl];
            /*
             *  check auto refresh time to fetch new data
             */
            NSInteger autoRefreshTime = [[NSUserDefaults standardUserDefaults] integerForKey:kAutoRefreshNewsTime];
            BOOL needRefresh = NO;
            if (cachedRss) {
                NSDate *lastUpdated = [cachedRss updatedAt];
                NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastUpdated];
                if (interval >= autoRefreshTime) {
                    needRefresh = YES;
                }else{
                    needRefresh = NO;
                }
            }
            if (!cachedRss || cachedRss.shouldCacheValue == NO || cachedRss.nodeList.count <= 0 || needRefresh) {
                
                manager = [[RssManager alloc] initWithRssUrl:[NSURL URLWithString:currentNode.nodeUrl]];
                [manager startParseCompletion:^(RssModel *rssModel, NSMutableArray *nodeList) {
                    
                    [cachedRss setUpdatedAt:[NSDate date]];
                    
                    NodeListViewController *viewcontroller = [NodeListViewController initWithNibName];
                    [viewcontroller setNodeList:nodeList];
                    [viewcontroller setRssURL:currentNode.nodeUrl];
                    [viewcontroller setTitle:currentNode.nodeTitle];
                    [self.navigationController pushViewController:viewcontroller animated:YES];
                    
                } failure:^(NSError *error) {
                    
                }];
                
            }else{
                NSMutableArray *nodeList = [NSMutableArray array];
                for (RssNode *node in cachedRss.nodeList) {
                    RssNodeModel *aNode = [[RssNodeModel alloc] initWithRssNode:node];
                    [nodeList addObject:aNode];
                }
                
                NodeListViewController *viewcontroller = [NodeListViewController initWithNibName];
                [viewcontroller setNodeList:nodeList];
                [viewcontroller setRssURL:currentNode.nodeUrl];
                [viewcontroller setTitle:currentNode.nodeTitle];
                [self.navigationController pushViewController:viewcontroller animated:YES];
            }
        }
            break;
        case NODE_TYPE_VIDEO:
        {
            moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:currentNode.nodeUrl]];
            [self presentMoviePlayerViewControllerAnimated:moviePlayer];
        }
            break;
        case NODE_TYPE_MP4:
        {
            moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:currentNode.nodeUrl]];
            [self presentMoviePlayerViewControllerAnimated:moviePlayer];
        }
            break;
        case NODE_TYPE_YOUTUBE:
        {
            XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:[currentNode.nodeUrl extractYoutubeId]];
            [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
        }
            break;
        case NODE_TYPE_DAILYMOTION:
        {
            NSString *url = currentNode.nodeUrl;
            NSString *videoIdentifer = [url lastPathComponent];
            
            DMPlayerViewController *playerViewcontroller = [[DMPlayerViewController alloc] initWithVideo:videoIdentifer];
            [playerViewcontroller setTitle:currentNode.nodeTitle];
            [playerViewcontroller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:playerViewcontroller animated:YES];
        }
            break;
        case NODE_TYPE_WEB_CONTENT:
        {
            FileListViewController *viewcontroller = [Storyboard instantiateViewControllerWithIdentifier:@"FileListViewController"];
            [viewcontroller setTitle:currentNode.nodeTitle];
            [viewcontroller setWebPageUrl:currentNode.nodeUrl];
            [self.navigationController pushViewController:viewcontroller animated:YES];
        }
            break;
        default:
        {
            WebViewViewController *viewcontroller = [WebViewViewController initWithNibName];
            [viewcontroller setTitle:currentNode.nodeTitle];
            [viewcontroller setWebUrl:currentNode.nodeUrl];
            [self.navigationController pushViewController:viewcontroller animated:YES];
        }
            break;
    }
}


#pragma mark search bar implement
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"nodeTitle contains[c] %@", searchText];
    searchResults = [_nodeList filteredArrayUsingPredicate:resultPredicate];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark Admob
#pragma mark Admob
#pragma mark Interstitial delegate

- (void)preLoadInterstitial
{
    //Call this method as soon as you can - loadRequest will run in the background and your interstitial will be ready when you need to show it
    
    NSDate *lastOpenDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastOpenFullScreen];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastOpenDate];
    
    if (interval <= kSecondsToPresentInterstitial) {
        [self continueAtCurrentPath];
        return;
    }
    if (_interstitial.isReady) {
        [_interstitial presentFromRootViewController:self];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastOpenFullScreen];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [self continueAtCurrentPath];
    }
}

-(GADInterstitial*) createAndLoadInterstital
{
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID ];
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:kLargeAdUnitId];
    interstitial.delegate = self;
    [interstitial loadRequest:request];
    
    return interstitial;
}

#pragma mark GADInterstitialDelegate
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
}
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    //If an error occurs and the interstitial is not received you might want to retry automatically after a certain interval
    _interstitial = [self createAndLoadInterstital];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    _interstitial = [self createAndLoadInterstital];
    [self continueAtCurrentPath];
}

#pragma mark NodeListCustomCellDelegate
-(void) NodeListCustomCell:(NodeListCustomCell *)cell didTapOnDownload:(id)sender
{
    willDownloadAtIndex = [self.tableView indexPathForCell:cell].row;
    /**
     *     let user enter the file name will be saved
     */
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *enterNameAction = [UIAlertAction actionWithTitle:@"New name" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       [self showAlertEnterFileName];
    }];
    UIAlertAction *defaultNameAction = [UIAlertAction actionWithTitle:@"Use default" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RssNodeModel *node = self.nodeList[willDownloadAtIndex];
        [[DownloadManager shareManager] downloadFile:node.nodeUrl name:node.nodeTitle thumbnail:node.nodeImage fromView:self];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:enterNameAction];
    [alertController addAction:defaultNameAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void) showAlertEnterFileName
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download video" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Download", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setPlaceholder:@"Put file name here."];
    [[alert textFieldAtIndex:0] setClearButtonMode:UITextFieldViewModeWhileEditing];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [label setText:@"*"];
    [label setTextColor:[UIColor redColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [[alert textFieldAtIndex:0] setRightViewMode:UITextFieldViewModeAlways];
    [[alert textFieldAtIndex:0] setRightView:label];
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeASCIICapable];
    [[alert textFieldAtIndex:0] setClearButtonMode:UITextFieldViewModeWhileEditing];
    [alert setTag:ALERT_ENTER_FILE_NAME];
    [alert show];
}

#pragma mark uialertview delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case ALERT_ENTER_FILE_NAME:
        {
            if (buttonIndex != alertView.cancelButtonIndex) {
                NSString *videoUrl = [self.nodeList[willDownloadAtIndex] nodeUrl];
                [[DownloadManager shareManager] downloadFile:videoUrl name:[[alertView textFieldAtIndex:0] text] thumbnail:[self.nodeList[willDownloadAtIndex] nodeImage] fromView:self];
            }
        }
            break;
            
        case ALERT_NAME_EXIST:
        {
            if (buttonIndex != alertView.cancelButtonIndex) {
                [self showAlertEnterFileName];
            }
        }
            break;
        default:
            break;
    }
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"BaseNodeListViewController: dealloc");
}

@end
