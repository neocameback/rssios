//
//  TempNode.h
//  MyRssReader
//
//  Created by Huyns89 on 5/30/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RssNodeModel : NSObject
@property (nonatomic, retain) NSString * bookmarkStatus;
@property (nonatomic, retain) NSString * nodeImage;
@property (nonatomic, retain) NSString * nodeSource;
@property (nonatomic, retain) NSString * nodeTitle;
@property (nonatomic, retain) NSString * nodeDesc;
@property (nonatomic, retain) NSString * nodeLink;
@property (nonatomic, retain) NSString * nodeType;
@property (nonatomic, retain) NSString * nodeUrl;
@property (nonatomic, retain) NSNumber * isAddedToBoomark;
@property (nonatomic, retain) NSNumber * isDeletedFlag;
@property (nonatomic, retain) NSArray * subtitles;

-(id) initWithFeedItem:(id) item;
-(id) initWithRssNode:(id) rssNode;
-(id) initWithBookmarkNode:(id) rssNode;
-(id) initWithFile:(id) file;
@end
