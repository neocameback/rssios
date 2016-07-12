//
//  RssManager.m
//  MyRssReader
//
//  Created by Huy on 6/15/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "RssManager.h"
#import "Reachability.h"

@implementation RssManager

-(id) initWithRssUrl:(NSURL *) url
{
    self = [super init];
    _rssUrl = url;
    
    return self;
}

-(void) startParseCompletion:(ParseCompletionBlock) completionBlock failure:(ParseFailedBlock) failedBlock
{
    if ([Singleton shareInstance].currentIpAddress) {
        
        [SVProgressHUD showWithStatus:kStringLoading maskType:SVProgressHUDMaskTypeGradient];
        _completionBlock = completionBlock;
        _failureBlock = failedBlock;
        
        NSString *ipAddress = [Singleton shareInstance].currentIpAddress;
        DLog(@"%@",ipAddress);
        NSMutableURLRequest *request = [Common requestWithMethod:@"GET" ipAddress:ipAddress Url:_rssUrl];
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
    }else{
        [SVProgressHUD showWithStatus:kStringLoading maskType:SVProgressHUDMaskTypeGradient];
        [Common getUserIpAddress:^(NSDictionary *update) {
            if (update) {
                
                _completionBlock = completionBlock;
                _failureBlock = failedBlock;
                
                NSString *ipAddress = update[@"ip"];
                [[Singleton shareInstance] setCurrentIpAddress:ipAddress];
                DLog(@"%@",ipAddress);
                NSMutableURLRequest *request = [Common requestWithMethod:@"GET" ipAddress:ipAddress Url:_rssUrl];
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
}

#pragma mark MWFeedParserDelegate
- (void)feedParserDidStart:(MWFeedParser *)parser
{
    _nodeList = [NSMutableArray array];
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info
{
    _rssModel = [[RssModel alloc] initWithFeedInfo:info];
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
    RssNodeModel *tempNode = [[RssNodeModel alloc] initWithFeedItem:item];
    [_nodeList addObject:tempNode];
}
- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    if (_completionBlock) {
        _completionBlock(_rssModel, _nodeList);
    }
    [SVProgressHUD popActivity];
}
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error
{
    if (_failureBlock) {
        _failureBlock(error);
    }
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
