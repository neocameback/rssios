//
//  RssListViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/23/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "RssListViewController.h"
#import "Rss.h"
#import "RssNode.h"
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isBookmarkRss == 1"];
        rssList = [[NSMutableArray alloc] initWithArray:[Rss MR_findAllSortedBy:@"rssTitle" ascending:YES withPredicate:predicate]];

        [_tableView reloadData];
    }
    else // first time lauche application, we'll save a sample RSS url
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [SVProgressHUD showWithStatus:kStringLoading maskType:SVProgressHUDMaskTypeGradient];
        [Common getUserIpAddress:^(NSDictionary *update) {
            if (update) {
                NSString *ipAddress = update[@"ip"];
                NSMutableURLRequest *request = [Common requestWithMethod:@"GET" ipAddress:ipAddress Url:kDefaultRssUrl];
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
    [viewcontroller setRssURL:[rssList[indexPath.row] rssLink]];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}
#pragma mark MWFeedParser delegate

- (void)feedParserDidStart:(MWFeedParser *)parser
{
    
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info
{
    TempRss *tempRss = [[TempRss alloc] initWithFeedInfo:info];
    /**
     *  create and save the default rss
     */
    defaultRss = [Rss MR_createEntity];
    [defaultRss setIsBookmarkRssValue:YES];
    [defaultRss setCreatedAt:[NSDate date]];
    [defaultRss initFromTempRss:tempRss];
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
    TempNode *tempNode = [[TempNode alloc] initWithFeedItem:item];
    
    RssNode *node = [RssNode MR_createEntity];
    [node setCreatedAt:[NSDate date]];
    [node initFromTempNode:tempNode];
    [node setRss:defaultRss];
}
- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    [SVProgressHUD popActivity];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        rssList = [[NSMutableArray alloc] initWithArray:[Rss MR_findAllSortedBy:@"rssTitle" ascending:YES]];
        [_tableView reloadData];
    }];
}
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error
{
    [SVProgressHUD popActivity];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                    message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}


@end
