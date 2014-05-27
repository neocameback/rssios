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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
