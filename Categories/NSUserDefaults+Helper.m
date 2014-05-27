//
//  NSUserDefaults+Helper.m
//  MyRssReader
//
//  Created by Huyns89 on 5/27/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "NSUserDefaults+Helper.h"

@implementation NSUserDefaults (Helper)
-(void) saveObject:(id) object forKey:(NSString*) key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void) deleteObjectForKey:(NSString*) key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
