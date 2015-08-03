//
//  Node.m
//  MyRssReader
//
//  Created by Huyns89 on 6/2/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "Node.h"


@implementation Node

@dynamic bookmarkStatus;
@dynamic isAddedToBoomark;
@dynamic isDeletedFlag;
@dynamic nodeImage;
@dynamic nodeSource;
@dynamic nodeTitle;
@dynamic nodeType;
@dynamic nodeUrl;
-(void) initFromTempNode:(TempNode*) temp
{
    self.bookmarkStatus = temp.bookmarkStatus;
    self.isAddedToBoomark = temp.isAddedToBoomark;
    self.nodeImage = temp.nodeImage;
    self.nodeSource = temp.nodeSource;
    self.nodeTitle = temp.nodeTitle;
    self.nodeUrl = temp.nodeUrl;
    self.nodeType = temp.nodeType;
    self.isDeletedFlag = temp.isDeletedFlag;
}

@end
