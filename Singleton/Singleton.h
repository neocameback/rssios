//
//  Singleton.h
//  Beyondsushi
//
//  Created by Huyns89 on 7/7/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject
@property (nonatomic, strong) NSString *currentIpAddress;
+(Singleton*) shareInstance;

@end
