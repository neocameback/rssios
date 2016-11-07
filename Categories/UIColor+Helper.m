//
//  UIColor+Helper.m
//  MyRssReader
//
//  Created by Huyns89 on 7/17/14.
//  Copyright (c) 2014 HuyNS. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)
+ (UIColor *)colorWithRGBHex:(UInt32)hex opacity:(CGFloat)opacity
{
    int r = ( hex >> 16 ) & 0xFF;
    int g = ( hex >> 8 ) & 0xFF;
    int b = (hex)&0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:opacity];
}
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if ( ![scanner scanHexInt:&hexNum] )
        return nil;
    return [UIColor colorWithRGBHex:hexNum opacity:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert opacity:(CGFloat) opacity {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if ( ![scanner scanHexInt:&hexNum] )
        return nil;
    return [UIColor colorWithRGBHex:hexNum opacity:opacity];
}

+(UIColor *)randomColor
{
    CGFloat red = arc4random() % 255 / 255.0;
    CGFloat green = arc4random() % 255 / 255.0;
    CGFloat blue = arc4random() % 255 / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    return color;
}

@end
