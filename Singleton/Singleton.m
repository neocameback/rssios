//
//  Singleton.m
//  Beyondsushi
//
//  Created by Huyns89 on 7/7/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "Singleton.h"

static Singleton *sharedInstance = nil;
@implementation Singleton

+(Singleton*) shareInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[super alloc] init];
    }    
    return sharedInstance;
}
@end
