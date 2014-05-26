//
//  UIViewController+Helper.m
//  MyRssReader
//
//  Created by Huyns89 on 5/26/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "UIViewController+Helper.h"

@implementation UIViewController (Helper)
+(id) initWithNibName
{
    return [[[self class] alloc] initWithNibName:[NSString stringWithFormat:@"%@",[[self class] description]] bundle:nil];
}

@end
