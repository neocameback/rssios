//
//  Common.m
//  MyRssReader
//
//  Created by Huyns89 on 8/24/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import "Common.h"

@implementation Common

+(NSString *) getPathOfFile:(NSString*) name extension:(NSString*) ext
{
    NSString *path = [NSTemporaryDirectory()  stringByAppendingPathComponent:name];
    path = [path stringByAppendingPathExtension:ext];
    
    return path;
}
@end
