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
#import <MWFeedParser.h>
#import <NSString+HTML.h>
#import <SVProgressHUD.h>

@interface AppDelegate() <MWFeedParserDelegate>
{
    MWFeedParser *feedParser;
    Rss *defaultRss;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // init core data
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    NSArray *rssList = [Rss MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    // init Rss List with a default Rss Link
    if (rssList.count <= 0) {
        NSURL *feedURL = [NSURL URLWithString:@"http://rssvideoplayer.com/sample.xml"];
        feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
        feedParser.delegate = self;
        // Parse the feeds info (title, link) and all feed items
        feedParser.feedParseType = ParseTypeFull;
        // Connection type
        feedParser.connectionType = ConnectionTypeAsynchronously;
        // Begin parsing
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [feedParser parse];
    }
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    HomeViewController *viewcontroller = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
    
    self.window.rootViewController = nav;    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)feedParserDidStart:(MWFeedParser *)parser
{
    
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info
{
    defaultRss = [Rss MR_createEntity];
    defaultRss.rssTitle = info.title;
    defaultRss.rssLink = info.link;
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
    Node *aNode = [Node MR_createEntity];
    aNode.nodeTitle = item.title;
//    aNode.nodeSource = item.s
    if (item.enclosures.count > 0) {
        aNode.nodeType = item.enclosures[0][@"type"];
        aNode.nodeUrl = item.enclosures[0][@"url"];
    }
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    [regex enumerateMatchesInString:item.summary
                            options:0
                              range:NSMakeRange(0, [item.summary length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             
                             aNode.nodeImage = [item.summary substringWithRange:[result rangeAtIndex:2]];
                             aNode.nodeImage = [aNode.nodeImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                         }];
    
    aNode.currentRss = defaultRss;
    
    [defaultRss addNodesObject:aNode];
}
- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    [SVProgressHUD dismiss];
    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        
    }];
}
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                    message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
