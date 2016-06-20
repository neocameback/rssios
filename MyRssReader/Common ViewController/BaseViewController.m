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
    _bannerView_.adUnitID = @"ca-app-pub-8422191650855912/2270603386";
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    _bannerView_.rootViewController = self;
    // Initiate a generic request to load it with an ad.
//    [_bannerView_ loadRequest:[GADRequest request]];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    GADRequest *request = [GADRequest request];
//    request.testDevices = @[ kGADSimulatorID ];
    [_bannerView_ loadRequest:request];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
