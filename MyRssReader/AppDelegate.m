//
//  AppDelegate.m
//  MyRssReader
//
//  Created by Huyns89 on 5/23/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "Rss.h"
#import "Node.h"
#import "MWFeedParser.h"
#import "NSString+HTML.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "JDStatusBarNotification.h"
#import "DownloadManager.h"
#import <Firebase.h>
#import <GoogleCast/GoogleCast.h>
#import "RssListViewController.h"
#import "RSSDrawerController.h"
#import "RSSLeftMenuViewController.h"

@interface AppDelegate() <GCKLoggerDelegate> {
    BOOL _enableSDKLogging;
    BOOL _mediaNotificationsEnabled;
    BOOL _firstUserDefaultsSync;
    BOOL _useCastContainerViewController;
}
@end
NSString *const kPrefPreloadTime = @"preload_time_sec";

static NSString *const kPrefEnableAnalyticsLogging =
@"enable_analytics_logging";
static NSString *const kPrefEnableSDKLogging = @"enable_sdk_logging";
static NSString *const kPrefAppVersion = @"app_version";
static NSString *const kPrefSDKVersion = @"sdk_version";
static NSString *const kPrefReceiverAppID = @"receiver_app_id";
static NSString *const kPrefCustomReceiverSelectedValue =
@"use_custom_receiver_app_id";
static NSString *const kPrefCustomReceiverAppID = @"custom_receiver_app_id";
static NSString *const kPrefEnableMediaNotifications =
@"enable_media_notifications";
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Use Firebase library to configure APIs
    [FIRApp configure];
    
    [Fabric with:@[[Crashlytics class]]];

    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticId];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger autoRefreshTime = [userDefault integerForKey:kAutoRefreshNewsTime];
    if (!autoRefreshTime || autoRefreshTime <= 0) {
        [userDefault setInteger:900 forKey:kAutoRefreshNewsTime];
    }
    [userDefault synchronize];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // init core data
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    [[DownloadManager shareManager] cancelDownloadingTasks];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self populateRegistrationDomain];
    NSString *applicationID = [self applicationIDFromUserDefaults];
    // Google Cast
    GCKCastOptions *options =
    [[GCKCastOptions alloc] initWithReceiverApplicationID:applicationID];
    [GCKCastContext setSharedInstanceWithOptions:options];
    [GCKCastContext sharedInstance].useDefaultExpandedMediaControls = YES;
    [GCKLogger sharedInstance].delegate = self;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(presentExpandedMediaControls)
     name:kGCKExpandedMediaControlsTriggeredNotification
     object:nil];
    [self setupRootViewController];
    [self setCustomUserAgent];
    [self setupDefaultValues];
    
    [self.window makeKeyAndVisible];
        
    return YES;
}

- (void)setupRootViewController {
    RSSLeftMenuViewController *leftMenuViewController = [RSSLeftMenuViewController initWithNibName];
    _drawerController = [[RSSDrawerController alloc] initWithCenterViewController:leftMenuViewController.centerViewController leftDrawerViewController:leftMenuViewController];
    [_drawerController setMaximumLeftDrawerWidth:300.0f];
    [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    GCKUICastContainerViewController *castContainerVC;
    castContainerVC = [[GCKCastContext sharedInstance]
                       createCastContainerControllerForViewController:_drawerController];
    self.window.rootViewController = castContainerVC;
}

- (void)setCustomUserAgent {
    NSString *userAgent = [Common getDefaultUserAgent];
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:userAgent, @"User-Agent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}

- (void)setupDefaultValues {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    /// check if default values have been set or not
    if (![userDefault objectForKey:kSubtitleFont]) {
        [self resetToDefaultValues];
    }
}

- (void)resetToDefaultValues {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"Verdana" forKey:kSubtitleFont];
    [userDefault setObject:@"ffffff" forKey:kSubtitleTextColor];
    if (isPhone) {
        [userDefault setInteger:17 forKey:kSubtitleTextSize];
    } else {
        [userDefault setInteger:19 forKey:kSubtitleTextSize];
    }
    [userDefault setObject:@"000000" forKey:kSubtitleBackgroundColor];
    [userDefault setFloat:50.0 forKey:kSubtitleOpacity];
    [userDefault synchronize];
}

#pragma mark Add these methods to control the visibility of the mini controller:

- (void)setCastControlBarsEnabled:(BOOL)notificationsEnabled {
    GCKUICastContainerViewController *castContainerVC;
    castContainerVC =
    (GCKUICastContainerViewController *)self.window.rootViewController;
    castContainerVC.miniMediaControlsItemEnabled = notificationsEnabled;
}

- (BOOL)castControlBarsEnabled {
    GCKUICastContainerViewController *castContainerVC;
    castContainerVC =
    (GCKUICastContainerViewController *)self.window.rootViewController;
    return castContainerVC.miniMediaControlsItemEnabled;
}

- (void)presentExpandedMediaControls {
    NSLog(@"present expanded media controls");
    // Segue directly to the ExpandedViewController.
    UINavigationController *navigationController;
    GCKUICastContainerViewController *castContainerVC;
    castContainerVC =
    (GCKUICastContainerViewController *)self.window.rootViewController;
    navigationController =
    (UINavigationController *)castContainerVC.contentViewController;
    
    navigationController.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    if (appDelegate.castControlBarsEnabled) {
        appDelegate.castControlBarsEnabled = NO;
    }
    [[GCKCastContext sharedInstance] presentDefaultExpandedMediaControls];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    application.idleTimerDisabled = NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.idleTimerDisabled = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[DownloadManager shareManager] cancelDownloadingTasks];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
#pragma mark GCKLoggerDelegate 
- (void)logMessage:(NSString *)message fromFunction:(NSString *)function {
    if (_enableSDKLogging) {
        NSLog(@"%@  %@", function, message);
    }
}

- (void)populateRegistrationDomain {
    NSURL *settingsBundleURL = [[NSBundle mainBundle] URLForResource:@"Settings"
                                                       withExtension:@"bundle"];
    NSString *appVersion = [[NSBundle mainBundle]
                            objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSMutableDictionary *appDefaults = [NSMutableDictionary dictionary];
    [self loadDefaults:appDefaults
      fromSettingsPage:@"Root"
 inSettingsBundleAtURL:settingsBundleURL];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:appDefaults];
    [userDefaults setValue:appVersion forKey:kPrefAppVersion];
    [userDefaults setValue:kGCKFrameworkVersion forKey:kPrefSDKVersion];
    [userDefaults synchronize];
}

- (void)loadDefaults:(NSMutableDictionary *)appDefaults
    fromSettingsPage:(NSString *)plistName
inSettingsBundleAtURL:(NSURL *)settingsBundleURL {
    NSString *plistFileName = [plistName stringByAppendingPathExtension:@"plist"];
    NSDictionary *settingsDict = [NSDictionary
                                  dictionaryWithContentsOfURL:
                                  [settingsBundleURL URLByAppendingPathComponent:plistFileName]];
    NSArray *prefSpecifierArray =
    [settingsDict objectForKey:@"PreferenceSpecifiers"];
    
    for (NSDictionary *prefItem in prefSpecifierArray) {
        NSString *prefItemType = prefItem[@"Type"];
        NSString *prefItemKey = prefItem[@"Key"];
        NSString *prefItemDefaultValue = prefItem[@"DefaultValue"];
        
        if ([prefItemType isEqualToString:@"PSChildPaneSpecifier"]) {
            NSString *prefItemFile = prefItem[@"File"];
            [self loadDefaults:appDefaults
              fromSettingsPage:prefItemFile
         inSettingsBundleAtURL:settingsBundleURL];
        } else if (prefItemKey && prefItemDefaultValue) {
            [appDefaults setObject:prefItemDefaultValue forKey:prefItemKey];
        }
    }
}

- (NSString *)applicationIDFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *prefApplicationID = [userDefaults stringForKey:kPrefReceiverAppID];
    if ([prefApplicationID isEqualToString:kPrefCustomReceiverSelectedValue]) {
        prefApplicationID = [userDefaults stringForKey:kPrefCustomReceiverAppID];
    }
    NSRegularExpression *appIdRegex =
    [NSRegularExpression regularExpressionWithPattern:@"\\b[0-9A-F]{8}\\b"
                                              options:0
                                                error:nil];
    NSUInteger numberOfMatches = [appIdRegex
                                  numberOfMatchesInString:prefApplicationID
                                  options:0
                                  range:NSMakeRange(0, [prefApplicationID length])];
    if (!numberOfMatches) {
        NSString *message = [NSString
                             stringWithFormat:
                             @"\"%@\" is not a valid application ID\n"
                             @"Please fix the app settings (should be 8 hex digits, in CAPS)",
                             prefApplicationID];
        ALERT_WITH_TITLE(@"Invalid Receiver Application ID", message)
        return nil;
    }
    return prefApplicationID;
}
@end
