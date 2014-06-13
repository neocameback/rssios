//
//  BaseViewController.h
//  MyRssReader
//
//  Created by Huyns89 on 5/28/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GADBannerView.h>
#import "GAITrackedViewController.h"

@interface BaseViewController : GAITrackedViewController
{
}
@property (nonatomic, strong) IBOutlet GADBannerView *bannerView_;
@end
