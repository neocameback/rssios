//
//  NSDictionary+Helper.h
//  MyRssReader
//
//  Created by Huyns89 on 6/17/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Helper)
-(NSString*) stringForKey:(NSString*) key;
-(NSInteger) integerForKey:(NSString*) key;
-(BOOL) boolForKey:(NSString*) key;
-(CGFloat) floatForKey:(NSString*) key;
-(NSString*) stringFromNumberForKey:(NSString*) key;
@end
