//
//  BaseViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/28/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
#if __IPHONE_7_0 >= 70000
    // iOS 7.0 or later
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
#endif
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
//    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // Specify the ad unit ID.
    [_bannerView_ setAdSize:kGADAdSizeBanner];
    _bannerView_.adUnitID = kSmallAdUnitId;
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    _bannerView_.rootViewController = self;
    // Initiate a generic request to load it with an ad.
//    [_bannerView_ loadRequest:[GADRequest request]];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_bannerView_ loadRequest:[GADRequest request]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(GADInterstitial*) createAndLoadInterstital
{
    GADRequest *request = [GADRequest request];
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:kLargeAdUnitId];
    interstitial.delegate = self;
    [interstitial loadRequest:request];
    
    return interstitial;
}

#pragma mark GADInterstitialDelegate
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
}
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    //If an error occurs and the interstitial is not received you might want to retry automatically after a certain interval
    [self createAndLoadInterstital];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    [self createAndLoadInterstital];
}

@end
