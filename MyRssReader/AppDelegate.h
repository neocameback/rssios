//
//  AppDelegate.h
//  MyRssReader
//
//  Created by Huyns89 on 5/23/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSDrawerController.h"

extern NSString *const kApplicationID;

extern NSString *const kPrefPreloadTime;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RSSDrawerController *drawerController;
@property (nonatomic) BOOL castControlBarsEnabled;
@end

#define appDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

