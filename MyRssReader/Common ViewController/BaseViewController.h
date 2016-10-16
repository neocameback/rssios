//
//  BaseViewController.h
//  MyRssReader
//
//  Created by Huyns89 on 5/28/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GAITrackedViewController.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface BaseViewController : GAITrackedViewController
{
}
//@property (nonatomic, strong) IBOutlet GADBannerView *bannerView_;
@property(nonatomic, weak) IBOutlet GADNativeExpressAdView *bannerView_;

@end
