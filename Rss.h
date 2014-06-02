//
//  Rss.h
//  MyRssReader
//
//  Created by Huyns89 on 6/2/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Rss : NSManagedObject

@property (nonatomic, retain) NSString * rssLink;
@property (nonatomic, retain) NSString * rssTitle;

@end
