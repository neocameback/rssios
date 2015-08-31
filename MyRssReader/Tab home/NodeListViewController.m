//
//  NodeListViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/26/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "NodeListViewController.h"
#import "Node.h"
#import <UIImageView+AFNetworking.h>
#import "NodeListCustomCell.h"
#import "WebViewViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <XCDYouTubeVideoPlayerViewController.h>
#import <DMPlayerViewController.h>
#import "MyMoviePlayerViewController.h"
#import <PureLayout.h>
#import <AFNetworking.h>
#import <AFDownloadRequestOperation.h>
#import <MBProgressHUD.h>
#import "DownloadManager.h"
#import "NSString+HTML.h"
#import "RPNodeDescriptionViewController.h"
#import "FileListViewController.h"

@interface NodeListViewController () <UIAlertViewDelegate>
{
    MPMoviePlayerViewController *moviePlayer;
    NodeListCustomCell *nodeCell;
    NSString *identifier;
    NSInteger willDownloadAtIndex;
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end
@implementation NodeListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /**
     *  retrieve the cached RSS
     */
    
    self.rssURL = @"http://feed.mikle.com/support/rss/";
    
    cachedRss = [Rss MR_findFirstByAttribute:@"rssLink" withValue:self.rssURL];
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
        [self parseRssFromURL:self.rssURL];
    }else{
        if (!nodeList) {
            nodeList = [NSMutableArray array];
        }
        for (RssNode *node in cachedRss.nodeList) {
            TempNode *aNode = [[TempNode alloc] initWithRssNode:node];
            [nodeList addObject:aNode];
        }
    }
    
    identifier = @"NodeListCustomCell";
    UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
    nodeCell = [nib instantiateWithOwner:self options:nil][0];
    [_tableView registerNib:nib forCellReuseIdentifier:identifier];
    [self.searchDisplayController.searchResultsTableView registerNib:nib forCellReuseIdentifier:identifier];
    
    interstitial_ = [self createAndLoadInterstital];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadDataSource)
                  forControlEvents:UIControlEventValueChanged];
    
    [_tableView addSubview:self.refreshControl];
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"Item List View";
    [self.tableView reloadData];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Save ManagedObjectContext using MagicalRecord
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
-(void) reloadDataSource
{
    [self parseRssFromURL:self.rssURL];
}
-(void) parseRssFromURL:(NSString *) url
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [Common getUserIpAddress:^(NSDictionary *update) {
        if (update) {
            NSString *ipAddress = update[@"ip"];
            NSMutableURLRequest *request = [Common requestWithMethod:@"GET" ipAddress:ipAddress Url:url];
            if (!request) {
                return;
            }
            feedParser = [[MWFeedParser alloc] initWithFeedRequest:request];
            
            feedParser.delegate = self;
            // Parse the feeds info (title, link) and all feed items
            feedParser.feedParseType = ParseTypeFull;
            // Connection type
            feedParser.connectionType = ConnectionTypeAsynchronously;
            // Begin parsing
            if ([self isInternetConnected]) {
                [feedParser parse];
            }else{
                [SVProgressHUD popActivity];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:kMessageInternetConnectionLost delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    } failureBlock:^(NSError * error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [SVProgressHUD popActivity];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate and datasource

-(CELL_TYPE) tableview:(UITableView*) tableView cellTypeForRowAtIndexPath:(NSIndexPath *) indexPath
{
    if( [nodeList[indexPath.row] isKindOfClass:[NSString class]] && [nodeList[indexPath.row] isEqualToString:@"Ads"]){
        return CELL_TYPE_AD;
    }else{
        return CELL_TYPE_NORMAL;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableview:tableView cellTypeForRowAtIndexPath:indexPath] == CELL_TYPE_NORMAL) {
        
        TempNode *node = nodeList[indexPath.row];
        [nodeCell configWithNode:node];
        [nodeCell layoutIfNeeded];
        CGFloat height = [nodeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        if (height < 71) {
            return 71;
        }else{
            return height + 1;
        }
    }else{
        return 50;
    }
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return nodeList.count;
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TempNode *node = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        node = searchResults[indexPath.row];
    } else {
        node = nodeList[indexPath.row];
    }
    
    NodeListCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell configWithNode:node];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableview:tableView cellTypeForRowAtIndexPath:indexPath] == CELL_TYPE_NORMAL) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        currentNode = nil;
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            currentNode = searchResults[indexPath.row];
        } else {
            currentNode = nodeList[indexPath.row];
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
        
    }else{
        return;
    }
}

#pragma mark search bar implement
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"nodeTitle contains[c] %@", searchText];
    searchResults = [nodeList filteredArrayUsingPredicate:resultPredicate];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

-(void) onDownLoad:(id) sender
{
    willDownloadAtIndex = [sender tag];
    /**
     *     let user enter the file name will be saved
     */
    [self showAlertEnterFileName];
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

#pragma mark Admob
#pragma mark Interstitial delegate
-(GADInterstitial*) createAndLoadInterstital
{
    GADRequest *request = [GADRequest request];
    GADInterstitial * interstitial = nil;
    if (tempRss && tempRss.adsFullId && tempRss.adsFullId.length > 0) {
        interstitial = [[GADInterstitial alloc] initWithAdUnitID:tempRss.adsFullId];
    }else{
        interstitial = [[GADInterstitial alloc] initWithAdUnitID:kLargeAdUnitId];
    }
    interstitial.delegate = self;
    [interstitial loadRequest:request];
    
    return interstitial;
}

- (void)preLoadInterstitial {
    //Call this method as soon as you can - loadRequest will run in the background and your interstitial will be ready when you need to show it
    
    NSDate *lastOpenDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastOpenFullScreen];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastOpenDate];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastOpenFullScreen];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (interval <= kSecondsToPresentInterstitial) {
        [self continueAtCurrentPath];
        return;
    }
    if (interstitial_.isReady) {
        [interstitial_ presentFromRootViewController:self];
    }else{
        [self continueAtCurrentPath];
    }
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
}
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    //If an error occurs and the interstitial is not received you might want to retry automatically after a certain interval
    [self createAndLoadInterstital];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    [self createAndLoadInterstital];
    [self continueAtCurrentPath];
}

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
            NodeListViewController *viewcontroller = [NodeListViewController initWithNibName];
            [viewcontroller setRssURL:currentNode.nodeUrl];
            [viewcontroller setTitle:currentNode.nodeTitle];
            [self.navigationController pushViewController:viewcontroller animated:YES];
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
#pragma mark MWFeedParser delegate

- (void)feedParserDidStart:(MWFeedParser *)parser
{
    nodeList = [NSMutableArray array];
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info
{
    tempRss = [[TempRss alloc] initWithFeedInfo:info];
    /**
     *  the saved RSS can have an other name that's enter on manage RSS view
     */
    if (cachedRss && cachedRss.rssTitle.length > 0) {
        [tempRss setRssTitle:cachedRss.rssTitle];
    }
    /**
     *  check if this rss should be cache or not
     */
    if (tempRss.shouldCache) {
        if (!cachedRss) {
            cachedRss = [Rss MR_createEntity];
            [cachedRss setCreatedAt:[NSDate date]];
        }else {
            [[cachedRss nodeListSet] removeAllObjects];
        }
        if (!cachedRss.isBookmarkRssValue) {
            [cachedRss setIsBookmarkRssValue:NO];
        }
        [cachedRss initFromTempRss:tempRss];
    }
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
    TempNode *aNode = [[TempNode alloc] initWithFeedItem:item];
    [nodeList addObject:aNode];
    /**
     *  if this rss should be cache so create new RssNode entity
     */
    if (cachedRss && cachedRss.shouldCacheValue) {
        RssNode *node = [RssNode MR_createEntity];
        [node initFromTempNode:aNode];
        [node setCreatedAt:[NSDate date]];
        [node setRss:cachedRss];
    }
}
- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    [self.refreshControl endRefreshing];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [SVProgressHUD popActivity];
    
    [self.tableView reloadData];
}
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error
{
    [self.refreshControl endRefreshing];
    [SVProgressHUD popActivity];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                    message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark uialertview delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case ALERT_ENTER_FILE_NAME:
        {
            if (buttonIndex != alertView.cancelButtonIndex) {
                NSString *videoUrl = [nodeList[willDownloadAtIndex] nodeUrl];
                [[DownloadManager shareManager] downloadFile:videoUrl name:[[alertView textFieldAtIndex:0] text] fromView:self];
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
    moviePlayer = nil;
    nodeCell = nil;
}
@end
