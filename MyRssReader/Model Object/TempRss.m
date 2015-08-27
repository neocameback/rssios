//
//  TempRss.m
//  MyRssReader
//
//  Created by Huyns89 on 5/30/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "TempRss.h"
#import "MWFeedInfo.h"

@implementation TempRss
@synthesize rssTitle, rssLink, nodes, shouldCache;
@synthesize adsBannerId, adsFullId;

-(id) initWithFeedInfo:(MWFeedInfo *) info;
{
    self = [super init];
    self.rssTitle = info.title;
    self.rssLink = info.link;
    self.adsBannerId = info.adBannerId;
    self.adsFullId = info.adFullId;
    if ([info shouldCache] != nil && ([[info shouldCache] caseInsensitiveCompare:@"false"] == NSOrderedSame)) {
        self.shouldCache = NO;
    }else{
        self.shouldCache = YES;
    }
    return self;
}
@end
