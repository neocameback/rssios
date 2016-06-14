//
//  RssManager.h
//  MyRssReader
//
//  Created by Huy on 6/15/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFeedParser.h"

@interface RssManager : NSObject <MWFeedParserDelegate>
{
    MWFeedParser *_feedParser;
}
@property (nonatomic, strong, readonly) NSURL *rssUrl;
-(id) initWithRssUrl:(NSURL *) url;
-(void) startParse;
@end
