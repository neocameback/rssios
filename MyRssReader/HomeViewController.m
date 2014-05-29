//
//  HomeViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/23/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "HomeViewController.h"
#import "RssListViewController.h"
#import "ManageRssViewController.h"
#import "BookmarkViewController.h"
#import "AboutViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    RssListViewController *rssVC = [RssListViewController initWithNibName];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:rssVC];
    
    ManageRssViewController *addRssVC = [ManageRssViewController initWithNibName];
    UINavigationController *manageNav = [[UINavigationController alloc] initWithRootViewController:addRssVC];
    
    BookmarkViewController *bookmarkVC = [BookmarkViewController initWithNibName];
    UINavigationController *favoriteNav = [[UINavigationController alloc] initWithRootViewController:bookmarkVC];
    
    AboutViewController *aboutVC = [AboutViewController initWithNibName];
    UINavigationController *aboutNav = [[UINavigationController alloc] initWithRootViewController:aboutVC];
    
    self.viewControllers = @[homeNav, manageNav, favoriteNav, aboutNav];
    
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [self.tabBar.items objectAtIndex:3];
    
    tabBarItem1.title = @"Home";
    tabBarItem2.title = @"Channels";
    tabBarItem3.title = @"Favorites";
    tabBarItem4.title = @"About";
    
    [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"ic_home_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_home_normal"]];
    [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"ic_channel_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_channel_normal"]];
    [tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"ic_favorites_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_favorites_normal"]];
    [tabBarItem4 setFinishedSelectedImage:[UIImage imageNamed:@"ic_about_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_about_normal"]];
    
    UIColor *titleHighlightedColor = [UIColor colorWithRed:82/255.0 green:203/255.0 blue:149/255.0 alpha:1.0];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
