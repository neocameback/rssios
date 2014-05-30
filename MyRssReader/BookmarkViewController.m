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
    
    [self preLoadInterstitial];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(onEdit)];
    self.navigationItem.leftBarButtonItem = editButton;    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [bannerView_ loadRequest:[GADRequest request]];
    
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

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nodeList.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Node *node = nodeList[indexPath.row];
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Node *node = nodeList[indexPath.row];
    
    if ([node.nodeType caseInsensitiveCompare:@"web/html"] == NSOrderedSame){
        currentPath = indexPath;
        [interstitial_ presentFromRootViewController:self];
    }
    else if ([node.nodeType caseInsensitiveCompare:@"application/x-mpegurl"] == NSOrderedSame || [node.nodeType caseInsensitiveCompare:@"video/mp4"] == NSOrderedSame){
        currentPath = indexPath;
        [interstitial_ presentFromRootViewController:self];
    }
    else if ([node.nodeType caseInsensitiveCompare:@"rss/xml"] == NSOrderedSame) {
        feedParser = [[MWFeedParser alloc] initWithFeedRequest:[Constant initWithMethod:@"GET" andUrl:node.nodeUrl]];
        feedParser.delegate = self;
        // Parse the feeds info (title, link) and all feed items
        feedParser.feedParseType = ParseTypeFull;
        // Connection type
        feedParser.connectionType = ConnectionTypeAsynchronously;
        // Begin parsing
        if ([self isInternetConnected]) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
            [feedParser parse];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Internet connection was lost!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }else{
        currentPath = indexPath;
        [interstitial_ presentFromRootViewController:self];
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
    
    [node setIsAddedToBoomark:[NSNumber numberWithBool:NO]];
    if ([node.isDeletedFlag boolValue] == YES) {
        [node MR_deleteEntity];
    }
    [nodeList removeObjectAtIndex:indexPath.row];
    
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void) continueActionAtIndexPath:(NSIndexPath *) indexPath
{
    Node *node = nodeList[indexPath.row];
    if ([node.nodeType caseInsensitiveCompare:@"web/html"] == NSOrderedSame){
        WebViewViewController *viewcontroller = [WebViewViewController initWithNibName];
        [viewcontroller setTitle:node.nodeTitle];
        [viewcontroller setWebUrl:node.nodeUrl];
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
    else if ([node.nodeType caseInsensitiveCompare:@"application/x-mpegurl"] == NSOrderedSame || [node.nodeType caseInsensitiveCompare:@"video/mp4"] == NSOrderedSame){
        moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:node.nodeUrl]];
        [self presentViewController:moviePlayer animated:YES completion:nil];
    }else{
        WebViewViewController *viewcontroller = [WebViewViewController initWithNibName];
        [viewcontroller setTitle:node.nodeTitle];
        [viewcontroller setWebUrl:node.nodeUrl];
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
}

#pragma mark Admob
#pragma mark Interstitial delegate
- (void)preLoadInterstitial {
    //Call this method as soon as you can - loadRequest will run in the background and your interstitial will be ready when you need to show it
    GADRequest *request = [GADRequest request];
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.delegate = self;
    interstitial_.adUnitID = kLargeAdUnitId;
    [interstitial_ loadRequest:request];
}

- (void) showInterstitial
{
    //Call this method when you want to show the interstitial - the method should double check that the interstitial has not been used before trying to present it
    if (!interstitial_.hasBeenUsed) [interstitial_ presentFromRootViewController:self];
}
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    
}
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"didFailToReceiveAdWithError: %@",[error localizedDescription]);
    //If an error occurs and the interstitial is not received you might want to retry automatically after a certain interval
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(preLoadInterstitial) userInfo:nil repeats:NO];
}
- (void)interstitialWillPresentScreen:(GADInterstitial *)interstitial
{
    
}
- (void)interstitialWillDismissScreen:(GADInterstitial *)interstitial
{
    
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    NSLog(@"interstitialDidDismissScreen");
    
    [self continueActionAtIndexPath:currentPath];
}
- (void)interstitialWillLeaveApplication:(GADInterstitial *)interstitial
{
    
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
    Node *aNode = [Node MR_createEntity];
    aNode.nodeTitle = item.title;
    //    aNode.nodeSource = item.s
    if (item.enclosures.count > 0) {
        aNode.nodeType = item.enclosures[0][@"type"];
        aNode.nodeUrl = item.enclosures[0][@"url"];
    }
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    [regex enumerateMatchesInString:item.summary
                            options:0
                              range:NSMakeRange(0, [item.summary length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             
                             aNode.nodeImage = [item.summary substringWithRange:[result rangeAtIndex:2]];
                             aNode.nodeImage = [aNode.nodeImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                         }];
    
    aNode.currentRss = newRss;
    
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
