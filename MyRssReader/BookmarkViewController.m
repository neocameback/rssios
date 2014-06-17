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
#import <DailymotionSDK/DailymotionSDK.h>
#import "ELPlayerViewController.h"

@interface BookmarkViewController ()
{
    MPMoviePlayerViewController *moviePlayer;
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
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(onEdit)];
    self.navigationItem.leftBarButtonItem = editButton;
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
-(void) onAddToFav:(id) sender
{
    NSInteger tag = [sender tag];
    Node *node = nodeList[tag];
    
    [node setIsAddedToBoomark: [node.isAddedToBoomark boolValue] ? @0 : @1];
    
    [sender setSelected:[node.isAddedToBoomark boolValue]];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Node *node = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        node = [searchResults objectAtIndex:indexPath.row];
    } else {
        node = [nodeList objectAtIndex:indexPath.row];
    }
    
    switch ([Constant typeOfNode:node.nodeType]) {
        case NODE_TYPE_RSS:
        {
            NodeListViewController *viewcontroller = [NodeListViewController initWithNibName];
            [viewcontroller setRssLink:node.nodeUrl];
            [viewcontroller setTitle:node.nodeTitle];
            [self.navigationController pushViewController:viewcontroller animated:YES];
        }
            break;
        case NODE_TYPE_VIDEO:
        {
            [self preLoadInterstitial];
        }
            break;
        case NODE_TYPE_YOUTUBE:
        {
            [self preLoadInterstitial];
        }
            break;
        case NODE_TYPE_DAILYMOTION:
        {
            [self preLoadInterstitial];
        }
            break;
        case NODE_TYPE_RTMP:
        {
            [self preLoadInterstitial];
        }
            break;
            
        default:
        {
            [self preLoadInterstitial];
            WebViewViewController *viewcontroller = [WebViewViewController initWithNibName];
            [viewcontroller setTitle:node.nodeTitle];
            [viewcontroller setWebUrl:node.nodeUrl];
            [self.navigationController pushViewController:viewcontroller animated:YES];
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
    
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark Admob
#pragma mark Interstitial delegate
- (void)preLoadInterstitial {
    //Call this method as soon as you can - loadRequest will run in the background and your interstitial will be ready when you need to show it
    
    NSDate *lastOpenDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastOpenFullScreen];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastOpenDate];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastOpenFullScreen];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (interval <= 120) {
        [self continueAtCurrentPath];
        return;
    }
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeGradient];
    GADRequest *request = [GADRequest request];
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.delegate = self;
    interstitial_.adUnitID = kLargeAdUnitId;
    [interstitial_ loadRequest:request];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    [SVProgressHUD dismiss];
    NSLog(@"interstitialDidReceiveAd");
    [interstitial_ presentFromRootViewController:self];
}
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    [SVProgressHUD dismiss];
    NSLog(@"didFailToReceiveAdWithError: %@",[error localizedDescription]);
    //If an error occurs and the interstitial is not received you might want to retry automatically after a certain interval
}
- (void)interstitialWillPresentScreen:(GADInterstitial *)interstitial
{
    [SVProgressHUD dismiss];
}
- (void)interstitialWillDismissScreen:(GADInterstitial *)interstitial
{
    
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    NSLog(@"interstitialDidDismissScreen");
    [self continueAtCurrentPath];
}
- (void)interstitialWillLeaveApplication:(GADInterstitial *)interstitial
{
    
}

-(void) continueAtCurrentPath
{
    Node *node = nil;
    if (self.searchDisplayController.isActive) {
        node = [searchResults objectAtIndex:currentPath.row];
    } else {
        node = [nodeList objectAtIndex:currentPath.row];
    }
    switch ([Constant typeOfNode:node.nodeType]) {
        case NODE_TYPE_RSS:
        {
        }
            break;
        case NODE_TYPE_VIDEO:
        {
            moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:node.nodeUrl]];
            [self presentViewController:moviePlayer animated:YES completion:nil];
        }
            break;
        case NODE_TYPE_YOUTUBE:
        {
            XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:[node.nodeUrl extractYoutubeId]];
            [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
        }
            break;
        case NODE_TYPE_DAILYMOTION:
        {
            DMPlayerViewController *playerViewcontroller = [[DMPlayerViewController alloc] initWithVideo:@"x1ythnm"];
            [playerViewcontroller setTitle:@"Dailymotion"];
            [self.navigationController pushViewController:playerViewcontroller animated:YES];
        }
            break;
        case NODE_TYPE_RTMP:
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
            
            ELPlayerViewController *viewcontroller = [sb instantiateViewControllerWithIdentifier:@"ELPlayerViewController"];
            [viewcontroller setVideoUrl:node.nodeUrl];
            [viewcontroller setTitleName:node.nodeTitle];
            [self presentViewController:viewcontroller animated:YES completion:^{
                
            }];
        }
            break;
            
        default:
        {
        }
            break;
    }
}
#pragma mark MWFeedParser delegate
- (void)feedParserDidStart:(MWFeedParser *)parser
{
    
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info
{
    newRss = [Rss MR_createEntity];
    newRss.rssTitle = info.title;
    newRss.rssLink = info.link;
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
//    Node *aNode = [Node MR_createEntity];
//    aNode.nodeTitle = item.title;
//    //    aNode.nodeSource = item.s
//    if (item.enclosures.count > 0) {
//        aNode.nodeType = item.enclosures[0][@"type"];
//        aNode.nodeUrl = item.enclosures[0][@"url"];
//    }
//    NSError *error = NULL;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
//                                                                           options:NSRegularExpressionCaseInsensitive
//                                                                             error:&error];
//    
//    [regex enumerateMatchesInString:item.summary
//                            options:0
//                              range:NSMakeRange(0, [item.summary length])
//                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//                             
//                             aNode.nodeImage = [item.summary substringWithRange:[result rangeAtIndex:2]];
//                             aNode.nodeImage = [aNode.nodeImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                         }];
//    
//    aNode.currentRss = newRss;
    
}
- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    [SVProgressHUD dismiss];
    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    
    if (!nodeList) {
        nodeList = [[NSMutableArray alloc] init];
    }
    [nodeList addObject:newRss];
    [_tableView reloadData];
}
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                    message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
