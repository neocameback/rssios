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
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"ic_home_normal"] selectedImage:[UIImage imageNamed:@"ic_home_press"]];
    [homeNav setTabBarItem:tabBarItem1];
    
    ManageRssViewController *addRssVC = [ManageRssViewController initWithNibName];
    UINavigationController *manageNav = [[UINavigationController alloc] initWithRootViewController:addRssVC];
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"Channels" image:[UIImage imageNamed:@"ic_channel_normal"] selectedImage:[UIImage imageNamed:@"ic_channel_press"]];
    [manageNav setTabBarItem:tabBarItem2];
    
    BookmarkViewController *bookmarkVC = [BookmarkViewController initWithNibName];
    UINavigationController *favoriteNav = [[UINavigationController alloc] initWithRootViewController:bookmarkVC];
    UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"Favorites" image:[UIImage imageNamed:@"ic_favorites_normal"] selectedImage:[UIImage imageNamed:@"ic_favorites_press"]];
    [favoriteNav setTabBarItem:tabBarItem3];
    
    AboutViewController *aboutVC = [AboutViewController initWithNibName];
    UINavigationController *aboutNav = [[UINavigationController alloc] initWithRootViewController:aboutVC];
    UITabBarItem *tabBarItem4 = [[UITabBarItem alloc] initWithTitle:@"About" image:[UIImage imageNamed:@"ic_about_normal"] selectedImage:[UIImage imageNamed:@"ic_about_press"]];
    [aboutNav setTabBarItem:tabBarItem4];
    
    self.viewControllers = @[homeNav, manageNav, favoriteNav, aboutNav];
    
    
    UIColor *titleHighlightedColor = [UIColor colorWithRed:82/255.0 green:203/255.0 blue:149/255.0 alpha:1.0];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
