//
//  RssManager.h
//  MyRssReader
//
//  Created by Huy on 6/15/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFeedParser.h"
#import "RssModel.h"
#import "RssNodeModel.h"

typedef void (^ParseCompletionBlock)(RssModel *rssModel, NSMutableArray *nodeList);
typedef void (^ParseFailedBlock)(NSError *error);

@interface RssManager : NSObject <MWFeedParserDelegate>
{
    MWFeedParser *_feedParser;
    
    RssModel *_rssModel;
    NSMutableArray *_nodeList;
    
    ParseCompletionBlock _completionBlock;
    ParseFailedBlock _failureBlock;
}
@property (nonatomic, strong, readonly) NSURL *rssUrl;
-(id) initWithRssUrl:(NSURL *) url;
-(void) startParseCompletion:(ParseCompletionBlock) completionBlock failure:(ParseFailedBlock) failedBlock;
@end
