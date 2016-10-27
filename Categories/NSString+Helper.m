//
//  NSString+Helper.m
//  MyRssReader
//
//  Created by Huyns89 on 6/9/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)
-(NSString *) extractYoutubeId
{
    NSString *regexString = @"(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)";
    
    NSError *error = NULL;
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:regexString
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:self
                                                    options:0
                                                      range:NSMakeRange(0, [self length])];
    if (match) {
        NSRange videoIDRange = [match rangeAtIndex:0];
        NSString *substringForFirstMatch = [self substringWithRange:videoIDRange];
        return substringForFirstMatch;
    }else{
        return nil;
    }    
}

@end
