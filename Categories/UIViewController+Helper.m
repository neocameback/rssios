//
//  UIViewController+Helper.m
//  MyRssReader
//
//  Created by Huyns89 on 5/26/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "UIViewController+Helper.h"
#import "Reachability.h"
@implementation UIViewController (Helper)
+(id) initWithNibName
{
    return [[[self class] alloc] initWithNibName:[NSString stringWithFormat:@"%@",[[self class] description]] bundle:nil];
}
-(BOOL) isInternetConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
@end
