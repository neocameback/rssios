//
//  BaseViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/28/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "BaseViewController.h"
#import "Toast.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
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
    _bannerView_.adUnitID = kBannerAdUnitID;
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    _bannerView_.rootViewController = self;
    // Initiate a generic request to load it with an ad.
    
    // google cast function
    
    _sessionManager = [GCKCastContext sharedInstance].sessionManager;
    [_sessionManager addListener:self];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(castDeviceDidChange:)
     name:kGCKCastStateDidChangeNotification
     object:[GCKCastContext sharedInstance]];
}

- (void)castDeviceDidChange:(NSNotification *)notification {
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    GADRequest *request = [GADRequest request];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_bannerView_ loadRequest:request];
    });
    
    // make mini player visible
    appDelegate.castControlBarsEnabled = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCastButtonVisible:(BOOL)visible {
    // should be implemented inside sub viewcontroller
}
#pragma mark - GCKSessionManagerListener

- (void)sessionManager:(GCKSessionManager *)sessionManager
       didStartSession:(GCKSession *)session {
    NSLog(@"MediaViewController: sessionManager didStartSession %@", session);
    [self setCastButtonVisible:YES];
}

- (void)sessionManager:(GCKSessionManager *)sessionManager
      didResumeSession:(GCKSession *)session {
    NSLog(@"MediaViewController: sessionManager didResumeSession %@", session);
    [self setCastButtonVisible:YES];
}

- (void)sessionManager:(GCKSessionManager *)sessionManager
         didEndSession:(GCKSession *)session
             withError:(NSError *)error {
    [self setCastButtonVisible:YES];
    if (self.enableCastFunction) {
        NSLog(@"session ended with error: %@", error);
        NSString *message =
        [NSString stringWithFormat:@"The Casting session has ended.\n%@",
         [error description]];
        
        [Toast displayToastMessage:message
                   forTimeInterval:3
                            inView:[UIApplication sharedApplication].delegate.window];
    }
}

- (void)sessionManager:(GCKSessionManager *)sessionManager
didFailToStartSessionWithError:(NSError *)error {
    [self setCastButtonVisible:YES];
    if (self.enableCastFunction) {
        [self showAlertWithTitle:@"Failed to start a session"
                         message:[error description]];
    }
}

- (void)sessionManager:(GCKSessionManager *)sessionManager
didFailToResumeSession:(GCKSession *)session
             withError:(NSError *)error {
    [self setCastButtonVisible:YES];
    if (self.enableCastFunction) {
        [Toast displayToastMessage:@"The Casting session could not be resumed."
                   forTimeInterval:3
                            inView:[UIApplication sharedApplication].delegate.window];
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    ALERT_WITH_TITLE(title, message)
}

#pragma mark - GCKRequestDelegate

- (void)requestDidComplete:(GCKRequest *)request {
    NSLog(@"request %ld completed", (long)request.requestID);
}

- (void)request:(GCKRequest *)request didFailWithError:(GCKError *)error {
    NSLog(@"request %ld failed with error %@", (long)request.requestID, error);
}

#pragma mark load Media info
- (void)castMediaInfo:(GCKMediaInformation *) mediaInfo{
    GCKCastSession *session =
    [GCKCastContext sharedInstance].sessionManager.currentCastSession;
    if (session) {
        [session.remoteMediaClient loadMedia:mediaInfo
                                    autoplay:YES];
    }
    if (appDelegate.castControlBarsEnabled) {
        appDelegate.castControlBarsEnabled = NO;
    }
    [[GCKCastContext sharedInstance] presentDefaultExpandedMediaControls];
}

@end
