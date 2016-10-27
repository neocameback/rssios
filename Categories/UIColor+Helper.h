//
//  UIColor+Helper.h
//  MyRssReader
//
//  Created by Huyns89 on 7/17/14.
//  Copyright (c) 2014 HuyNS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helper)
+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+(UIColor *)randomColor;
@end
