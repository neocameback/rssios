//
//  Rss.m
//  MyRssReader
//
//  Created by Huyns89 on 6/2/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "Rss.h"
#import "RssModel.h"

@implementation Rss

-(void) initFromTempRss:(RssModel *) temp
{
    self.rssTitle = temp.rssTitle;
    self.rssLink = temp.rssLink;
    self.shouldCacheValue = temp.shouldCache;
    self.updatedAt = [NSDate date];
}
@end
