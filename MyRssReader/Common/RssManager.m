//
//  RssManager.m
//  MyRssReader
//
//  Created by Huy on 6/15/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "RssManager.h"
#import "Reachability.h"
#import "TempRss.h"
#import "TempNode.h"
#import "Rss.h"
#import "RssNode.h"


@implementation RssManager

-(id) initWithRssUrl:(NSURL *) url
{
    self = [super init];
    _rssUrl = url;
    
    return self;
}

-(void) startParse
{
    [SVProgressHUD showWithStatus:kStringLoading maskType:SVProgressHUDMaskTypeGradient];
    [Common getUserIpAddress:^(NSDictionary *update) {
        if (update) {
            NSString *ipAddress = update[@"ip"];
            NSMutableURLRequest *request = [Common requestWithMethod:@"GET" ipAddress:ipAddress Url:kDefaultRssUrl];
            if (!request) {
                return;
            }
            _feedParser = [[MWFeedParser alloc] initWithFeedRequest:request];
            
            _feedParser.delegate = self;
            // Parse the feeds info (title, link) and all feed items
            _feedParser.feedParseType = ParseTypeFull;
            // Connection type
            _feedParser.connectionType = ConnectionTypeAsynchronously;
            // Begin parsing
            if ([self isInternetConnected]) {
                [_feedParser parse];
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

#pragma mark MWFeedParserDelegate
- (void)feedParserDidStart:(MWFeedParser *)parser
{
    
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info
{
    TempRss *tempRss = [[TempRss alloc] initWithFeedInfo:info];
    /**
     *  create and save the default rss
     */
//    defaultRss = [Rss MR_createEntity];
//    [defaultRss setIsBookmarkRssValue:YES];
//    [defaultRss setCreatedAt:[NSDate date]];
//    [defaultRss initFromTempRss:tempRss];
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
    TempNode *tempNode = [[TempNode alloc] initWithFeedItem:item];
    
    RssNode *node = [RssNode MR_createEntity];
    [node setCreatedAt:[NSDate date]];
    [node initFromTempNode:tempNode];
//    [node setRss:defaultRss];
}
- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    [SVProgressHUD popActivity];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
//        rssList = [[NSMutableArray alloc] initWithArray:[Rss MR_findAllSortedBy:@"rssTitle" ascending:YES]];
//        [_tableView reloadData];
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

-(BOOL) isInternetConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
