//
//  TempRss.h
//  MyRssReader
//
//  Created by Huyns89 on 5/30/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempRss : NSObject
@property (nonatomic, retain) NSString * rssLink;
@property (nonatomic, retain) NSString * rssTitle;
@property (nonatomic, retain) NSMutableArray *nodes;

@end
