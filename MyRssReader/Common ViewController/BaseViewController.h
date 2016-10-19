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
#import <GoogleCast/GoogleCast.h>

@interface BaseViewController : GAITrackedViewController <GCKSessionManagerListener, GCKRequestDelegate>
{
}
//@property (nonatomic, strong) IBOutlet GADBannerView *bannerView_;
@property(nonatomic, weak) IBOutlet GADNativeExpressAdView *bannerView_;
// specifi if this viewcontroller is allowed to cast video
@property (nonatomic) BOOL enableCastFunction;

@property (nonatomic, strong) GCKSessionManager *sessionManager;
@property (nonatomic, strong) GCKCastSession *castSession;
- (void)castMediaInfo:(GCKMediaInformation *) mediaInfo;
@end
