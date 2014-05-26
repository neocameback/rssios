//
//  Rss.h
//  MyRssReader
//
//  Created by Huyns89 on 5/26/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Node;

@interface Rss : NSManagedObject

@property (nonatomic, retain) NSString * rssTitle;
@property (nonatomic, retain) NSString * rssLink;
@property (nonatomic, retain) NSSet *nodes;
@end

@interface Rss (CoreDataGeneratedAccessors)

- (void)addNodesObject:(Node *)value;
- (void)removeNodesObject:(Node *)value;
- (void)addNodes:(NSSet *)values;
- (void)removeNodes:(NSSet *)values;

@end
