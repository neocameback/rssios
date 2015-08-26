//
//  Node.h
//  MyRssReader
//
//  Created by Huyns89 on 6/2/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "TempNode.h"
#import "_Node.h"

/**
 Favorited Node model
 */
@interface Node : _Node

-(void) initFromTempNode:(TempNode*) temp;
@end
