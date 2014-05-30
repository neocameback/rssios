//
//  TempNode.h
//  MyRssReader
//
//  Created by Huyns89 on 5/30/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempNode : NSObject
@property (nonatomic, retain) NSString * bookmarkStatus;
@property (nonatomic, retain) NSString * nodeImage;
@property (nonatomic, retain) NSString * nodeSource;
@property (nonatomic, retain) NSString * nodeTitle;
@property (nonatomic, retain) NSString * nodeType;
@property (nonatomic, retain) NSString * nodeUrl;
@property (nonatomic, retain) NSNumber * isAddedToBoomark;
@property (nonatomic, retain) NSNumber * isDeletedFlag;
@end
