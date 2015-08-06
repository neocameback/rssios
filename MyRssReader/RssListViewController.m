//
//  RssListViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/23/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "RssListViewController.h"
#import "Rss.h"
#import "Node.h"
#import "NodeListViewController.h"
#import "MWFeedParser.h"

@interface RssListViewController () <MWFeedParserDelegate>
{
    NSMutableArray *rssList;
    MWFeedParser *feedParser;
    Rss *defaultRss;
}
@end

@implementation RssListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Home";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
}
-(void) showBanner
{
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.screenName = @"Home View";
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        rssList = [[NSMutableArray alloc] initWithArray:[Rss MR_findAllSortedBy:@"rssTitle" ascending:YES]];
        [_tableView reloadData];
    }
    else // first time lauche application, we'll save a sample RSS url
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        feedParser = [[MWFeedParser alloc] initWithFeedRequest:[Constant requestWithMethod:@"GET" andUrl:kDefaultRssUrl]];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:kMessageInternetConnectionLost delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rssList.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [rssList[indexPath.row] rssTitle];
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NodeListViewController *viewcontroller = [NodeListViewController initWithNibName];
    [viewcontroller setTitle:[rssList[indexPath.row] rssTitle]];
    [viewcontroller setRssLink:[rssList[indexPath.row] rssLink]];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}
#pragma mark MWFeedParser delegate

- (void)feedParserDidStart:(MWFeedParser *)parser
{
    
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info
{
    defaultRss = [Rss MR_createEntity];
    defaultRss.rssTitle = info.title;
    defaultRss.rssLink = info.link;
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
//    Node *aNode = [Node MR_createEntity];
//    aNode.nodeTitle = item.title;
//    aNode.bookmarkStatus = item.bookmarkStatus;
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
//    aNode.currentRss = defaultRss;
    
}
- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    [SVProgressHUD dismiss];
    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        rssList = [[NSMutableArray alloc] initWithArray:[Rss MR_findAllSortedBy:@"rssTitle" ascending:YES]];
        [_tableView reloadData];
    }];
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
