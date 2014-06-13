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

@interface NodeListViewController ()
{
    MPMoviePlayerViewController *moviePlayer;
}
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
    [self parseRssFromURL:self.rssLink];
    
//    [self preLoadInterstitial];
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

-(void) parseRssFromURL:(NSString *) url
{
    feedParser = [[MWFeedParser alloc] initWithFeedRequest:[Constant requestWithMethod:@"GET" andUrl:url]];
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
}

-(void) appendAdsNode
{
    for (int i = ad_range - 1; i < nodeList.count; i = i + ad_range) {
        [nodeList insertObject:@"Ads" atIndex:i];
    }
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
        return 61;
    }else{
        return 50;
    }
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nodeList.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableview:tableView cellTypeForRowAtIndexPath:indexPath] == CELL_TYPE_NORMAL) {
        TempNode *node = nodeList[indexPath.row];
        
        NSString *identifier = @"NodeListCustomCell";
        NodeListCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NodeListCustomCell" owner:self options:nil][0];
        }
        [cell configWithNode:node];
        
        [cell.btn_addToFav addTarget:self action:@selector(onAddToFav:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_addToFav setTag:indexPath.row];
        return cell;
    }else{
        NSString *identifier = @"NodeListAdCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        // Specify the ad unit ID.
        
        bannerView.adUnitID = kSmallAdUnitId;
        bannerView.rootViewController = self;

        [cell.contentView addSubview:bannerView];
        [bannerView loadRequest:[GADRequest request]];
        
        return cell;
    }
}

-(void) onAddToFav:(id) sender
{
    NSInteger tag = [sender tag];
    
    TempNode *temp = nodeList[tag];
    NSString *nodeUrl = [nodeList[tag] nodeUrl];
    if ([[temp isAddedToBoomark] boolValue]) {
        Node *node = [Node MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"nodeUrl == %@",nodeUrl] inContext:[NSManagedObjectContext MR_defaultContext]];
        [node MR_deleteEntity];
        [temp setIsAddedToBoomark: [temp.isAddedToBoomark boolValue] ? @0 : @1];
    }else{
        Node *node = [Node MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"nodeUrl == %@",nodeUrl] inContext:[NSManagedObjectContext MR_defaultContext]];
        if (!node) {
            node = [Node MR_createEntity];
        }
        [temp setIsAddedToBoomark: [temp.isAddedToBoomark boolValue] ? @0 : @1];
        [node initFromTempNode:nodeList[tag]];
    }
    [self.tableView reloadData];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentPath = indexPath;
    if ([self tableview:tableView cellTypeForRowAtIndexPath:indexPath] == CELL_TYPE_NORMAL) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        TempNode *node = nodeList[indexPath.row];
        if ([node.nodeType caseInsensitiveCompare:@"web/html"] == NSOrderedSame){
            [self preLoadInterstitial];
            WebViewViewController *viewcontroller = [WebViewViewController initWithNibName];
            [viewcontroller setTitle:node.nodeTitle];
            [viewcontroller setWebUrl:node.nodeUrl];
            [self.navigationController pushViewController:viewcontroller animated:YES];
        }
        else if ([node.nodeType caseInsensitiveCompare:@"application/x-mpegurl"] == NSOrderedSame || [node.nodeType caseInsensitiveCompare:@"video/mp4"] == NSOrderedSame || [node.nodeType caseInsensitiveCompare:@"rtmp/flv"] == NSOrderedSame ){
            [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeGradient];
            [self preLoadInterstitial];
        }else if ([node.nodeType caseInsensitiveCompare:@"rss/xml"] == NSOrderedSame){
            /**
             *  parse rss/xml
             */
            NodeListViewController *viewcontroller = [NodeListViewController initWithNibName];
            [viewcontroller setRssLink:node.nodeUrl];
            [viewcontroller setTitle:node.nodeTitle];
            [self.navigationController pushViewController:viewcontroller animated:YES];
        }else{
            [self preLoadInterstitial];
            WebViewViewController *viewcontroller = [WebViewViewController initWithNibName];
            [viewcontroller setTitle:node.nodeTitle];
            [viewcontroller setWebUrl:node.nodeUrl];
            [self.navigationController pushViewController:viewcontroller animated:YES];
        }
        
    }else{
        return;
    }
}

#pragma mark Admob
#pragma mark Interstitial delegate
- (void)preLoadInterstitial {
    //Call this method as soon as you can - loadRequest will run in the background and your interstitial will be ready when you need to show it
    GADRequest *request = [GADRequest request];
    interstitial_ = nil;
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
    TempNode *node = nodeList[currentPath.row];
    if ([node.nodeType caseInsensitiveCompare:@"application/x-mpegurl"] == NSOrderedSame || [node.nodeType caseInsensitiveCompare:@"video/mp4"] == NSOrderedSame || [node.nodeType caseInsensitiveCompare:@"rtmp/flv"] == NSOrderedSame ){
        moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:node.nodeUrl]];
        [self presentViewController:moviePlayer animated:YES completion:nil];
    }
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
    tempRss = [[TempRss alloc] init];
    
    tempRss.rssTitle = info.title;
    tempRss.rssLink = info.link;
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
    TempNode *aNode = [[TempNode alloc] init];
    aNode.bookmarkStatus = item.bookmarkStatus;
    aNode.nodeTitle = item.title;
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
    
    if (!nodeList) {
        nodeList = [NSMutableArray array];
    }
    [nodeList addObject:aNode];
}
- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    [SVProgressHUD dismiss];
    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    
    [self appendAdsNode];
    
    [self.tableView reloadData];
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
