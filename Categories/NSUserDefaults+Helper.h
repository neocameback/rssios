//
//  NSUserDefaults+Helper.h
//  MyRssReader
//
//  Created by Huyns89 on 5/27/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Helper)
-(void) saveObject:(id) object forKey:(NSString*) key;
-(void) deleteObjectForKey:(NSString*) key;
@end
