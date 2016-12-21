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

-(void) hudTapped:(NSNotification *) notification
{
    DLog(@"");
    [_feedParser stopParsing];
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SVProgressHUDDidReceiveTouchEventNotification object:nil];

}
-(void) startParseCompletion:(ParseCompletionBlock) completionBlock failure:(ParseFailedBlock) failedBlock
{
    NSLog(@"parsing URL: %@",_rssUrl);
    if ([Singleton shareInstance].currentIpAddress) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudTapped:) name:SVProgressHUDDidReceiveTouchEventNotification object:nil];
        [SVProgressHUD showWithStatus:kStringLoadingTapToCancel];
        _completionBlock = completionBlock;
        _failureBlock = failedBlock;
        
        NSString *ipAddress = [Singleton shareInstance].currentIpAddress;
        DLog(@"%@",ipAddress);
        NSMutableURLRequest *request = [Common requestWithMethod:@"GET" ipAddress:ipAddress Url:_rssUrl];
        if (!request) {
            return;
        }
        if (!_feedParser) {
            _feedParser = [[MWFeedParser alloc] initWithFeedRequest:request];
            _feedParser.delegate = self;
            // Parse the feeds info (title, link) and all feed items
            _feedParser.feedParseType = ParseTypeFull;
            // Connection type
            _feedParser.connectionType = ConnectionTypeAsynchronously;
        }
        // Begin parsing
        if ([self isInternetConnected]) {
            [_feedParser parse];
        }else{
            [SVProgressHUD popActivity];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:kMessageInternetConnectionLost delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudTapped:) name:SVProgressHUDDidReceiveTouchEventNotification object:nil];
        [SVProgressHUD showWithStatus:kStringLoadingTapToCancel];
        [Common getUserIpAddress:^(NSDictionary *update) {
            if (update) {
                
                _completionBlock = completionBlock;
                _failureBlock = failedBlock;
                
                NSString *ipAddress = update[@"query"];
                [[Singleton shareInstance] setCurrentIpAddress:ipAddress];
                DLog(@"%@",ipAddress);
                NSMutableURLRequest *request = [Common requestWithMethod:@"GET" ipAddress:ipAddress Url:_rssUrl];
                if (!request) {
                    return;
                }
                if (!_feedParser) {
                    _feedParser = [[MWFeedParser alloc] initWithFeedRequest:request];
                    _feedParser.delegate = self;
                    // Parse the feeds info (title, link) and all feed items
                    _feedParser.feedParseType = ParseTypeFull;
                    // Connection type
                    _feedParser.connectionType = ConnectionTypeAsynchronously;
                }
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
    if (parser.isStopped) {
        /**
         *  if parser is told to be stopped so just dismiss the progresshud
         */
    }else{
        if (_completionBlock) {
            _completionBlock(_rssModel, _nodeList);
        }
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
                                                    message:@"There was an error during the parsing of this feed. Not all of the feed items could be parsed."
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

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
