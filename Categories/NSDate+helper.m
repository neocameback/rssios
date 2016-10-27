//
//  NSDate+helper.m
//  MyRssReader
//
//  Created by Huy Nguyen on 10/27/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "NSDate+helper.h"

@implementation NSDate (helper)

- (double)toMilliseconds {
    return (long long)([self timeIntervalSince1970] * 1000.0);
}
@end
