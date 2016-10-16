//
//  NSDictionary+Helper.m
//  MyRssReader
//
//  Created by Huyns89 on 6/17/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "NSDictionary+Helper.h"

@implementation NSDictionary (Helper)
-(NSString*) stringForKey:(NSString*) key
{
    if (self[key]) {
        return [self[key] isKindOfClass:[NSNull class]] ? @"" : self[key];
    }else{
        return @"";
    }
}
-(NSInteger) integerForKey:(NSString*) key
{
    if (self[key]) {
        return [self[key] isKindOfClass:[NSNull class]] ? 0 : [self[key] integerValue];
    }else{
        return 0;
    }
}
-(BOOL) boolForKey:(NSString*) key
{
    if (self[key]) {
        return [self[key] isKindOfClass:[NSNull class]] ? NO : [self[key] boolValue];
    }else{
        return NO;
    }
}
-(CGFloat) floatForKey:(NSString*) key
{
    if (self[key]) {
        return [self[key] isKindOfClass:[NSNull class]] ? 0 : [self[key] floatValue];
    }else{
        return 0;
    }
}
-(NSString*) stringFromNumberForKey:(NSString*) key
{
    if (self[key]) {
        return [self[key] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%ld",(long)[self integerForKey:key]];
    }else{
        return @"";
    }
}

@end
