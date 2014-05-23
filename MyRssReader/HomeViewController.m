//
//  HomeViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/23/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "HomeViewController.h"
#import "RssListViewController.h"
#import "AddNewRssViewController.h"
#import "BookmarkViewController.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onHomeButton:(id)sender {
    RssListViewController *vc = [[RssListViewController alloc] initWithNibName:@"RssListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onAddNew:(id)sender {
    AddNewRssViewController *vc = [[AddNewRssViewController alloc] initWithNibName:@"AddNewRssViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onShowBookmar:(id)sender {
    BookmarkViewController *vc = [[BookmarkViewController alloc] initWithNibName:@"BookmarkViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onAbout:(id)sender {
}
@end
