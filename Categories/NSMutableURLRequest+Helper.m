//
//  NSMutableURLRequest+Helper.m
//  MyRssReader
//
//  Created by Huyns89 on 5/28/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "NSMutableURLRequest+Helper.h"

@implementation NSMutableURLRequest (Helper)
-(id) initWithMethod:(NSString *) method andUrl:(NSString *) url
{
    if (!self) {
        self = [super init];
    }
    NSString *ipAddres = [Constant getIpAddress];
    NSString *md5String = [[NSString stringWithFormat:@"%@%@",kDefaultMd5Prefix,ipAddres] MD5String];
    [self setHTTPMethod:method];
    [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?Auth=%@",url,md5String]]];
    
    return self;
}
@end
