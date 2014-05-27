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
#import <XCDYouTubeVideoPlayerViewController.h>
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
    self.title = _currentRss.rssTitle;
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Save ManagedObjectContext using MagicalRecord
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currentRss.nodes.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Node *node = [_currentRss nodes][indexPath.row];
    
    NSString *identifier = @"NodeListCustomCell";
    NodeListCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NodeListCustomCell" owner:self options:nil][0];
    }
    [cell configWithNode:node];
    
    [cell.btn_addToFav addTarget:self action:@selector(onAddToFav:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_addToFav setTag:indexPath.row];
    return cell;
}
-(void) onAddToFav:(id) sender
{
    NSInteger tag = [sender tag];
    Node *node = [_currentRss nodes][tag];
    
    [node setIsAddedToBoomark: [node.isAddedToBoomark boolValue] ? @0 : @1];
    
    [sender setSelected:[node.isAddedToBoomark boolValue]];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Node *node = [_currentRss nodes][indexPath.row];
    
    if ([node.nodeType caseInsensitiveCompare:@"web/html"] == NSOrderedSame){
        WebViewViewController *viewcontroller = [WebViewViewController initWithNibName];
        [viewcontroller setWebUrl:node.nodeUrl];
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
    else if ([node.nodeType caseInsensitiveCompare:@"application/x-mpegurl"] == NSOrderedSame || [node.nodeType caseInsensitiveCompare:@"video/mp4"] == NSOrderedSame){
//        if (!moviewPlayer) {
            moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:node.nodeUrl]];
//        }
        [self presentViewController:moviePlayer animated:YES completion:nil];
    }else{
        NSURL *feedURL = [NSURL URLWithString:[node nodeUrl]];
        feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
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
}

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
    
    aNode.currentRss = newRss;
}
- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    [SVProgressHUD dismiss];
    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    
    NodeListViewController *viewcontroller = [NodeListViewController initWithNibName];
    [viewcontroller setCurrentRss:newRss];
    [self.navigationController pushViewController:viewcontroller animated:YES];
    
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
