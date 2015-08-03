//
//  Node.h
//  MyRssReader
//
//  Created by Huyns89 on 6/2/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "_Node.h"
#import "TempNode.h"

@interface Node : _Node

-(void) initFromTempNode:(TempNode*) temp;
@end
