//
//  Node.m
//  MyRssReader
//
//  Created by Huyns89 on 6/2/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "Node.h"


@implementation Node

-(void) initFromTempNode:(RssNodeModel*) temp
{
    [self setUpdatedAt:[NSDate date]];
    self.bookmarkStatus = temp.bookmarkStatus;
    self.isAddedToBoomark = temp.isAddedToBoomark;
    self.nodeImage = temp.nodeImage;
    self.nodeSource = temp.nodeSource;
    self.nodeTitle = temp.nodeTitle;
    self.nodeDesc = temp.nodeDesc;
    self.nodeUrl = temp.nodeUrl;
    self.nodeLink = temp.nodeLink;
    self.nodeType = temp.nodeType;
    self.isDeletedFlag = temp.isDeletedFlag;
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (MWFeedItemSubTitle *sub in temp.subtitles) {
        Subtitle *subtitle = [Subtitle MR_createEntity];
        subtitle.createdAt = [NSDate date];
        
        [subtitle setBookmarkedNode:self];
        [subtitle initFromSubtitleItem:sub];
        
        [tempArray addObject:subtitle];
    }
    self.subtitles = [NSOrderedSet orderedSetWithArray:tempArray];
}

@end
