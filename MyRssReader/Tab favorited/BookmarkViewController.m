//
//  BookmarkViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/23/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "BookmarkViewController.h"
#import "Node.h"
#import "BookmarkCustomCell.h"
#import "WebViewViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NodeListViewController.h"
#import <XCDYouTubeVideoPlayerViewController.h>
#import <DMPlayerViewController.h>
#import "FileListViewController.h"
#import "RPNodeDescriptionViewController.h"

@interface BookmarkViewController ()
{
    MPMoviePlayerViewController *moviePlayer;
    Node *currentNode;
}
@end

@implementation BookmarkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Favorites";        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onEdit)];
    self.navigationItem.leftBarButtonItem = editButton;
    
    interstitial_ = [self createAndLoadInterstital];
    
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.screenName = @"Favorites View";
    
    if (!nodeList) {
        nodeList = [[NSMutableArray alloc] init];
    }else{
        [nodeList removeAllObjects];
    }
    nodeList = [[NSMutableArray alloc] initWithArray:[Node MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"isAddedToBoomark == 1"]]];
    [_tableView reloadData];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Save ManagedObjectContext using MagicalRecord
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

-(void) onEdit
{
    if (_tableView.editing) {
        _tableView.editing = NO;
    }else{
        _tableView.editing = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark search display delegate
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"nodeTitle contains[c] %@", searchText];
    searchResults = [NSMutableArray arrayWithArray:[nodeList filteredArrayUsingPredicate:resultPredicate]];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark tableview datasource, delegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [nodeList count];
    }
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Node *node = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        node = [searchResults objectAtIndex:indexPath.row];
    } else {
        node = [nodeList objectAtIndex:indexPath.row];
    }
    
    NSString *identifier = @"BookmarkCustomCell";
    BookmarkCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"BookmarkCustomCell" owner:self options:nil][0];
    }
    [cell configWithNode:node];
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
}
-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Node *node = nodeList[indexPath.row];
    [node MR_deleteEntity];
    [nodeList removeObjectAtIndex:indexPath.row];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [_tableView reloadData];
}

#pragma mark Admob
#pragma mark Interstitial delegate
-(GADInterstitial*) createAndLoadInterstital
{
    GADRequest *request = [GADRequest request];
    GADInterstitial * interstitial = nil;
    interstitial = [[GADInterstitial alloc] initWithAdUnitID:kLargeAdUnitId];
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
@end
