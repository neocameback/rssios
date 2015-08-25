//
//  RPNodeDescriptionViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 8/25/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import "RPNodeDescriptionViewController.h"
#import "WebViewViewController.h"

@interface RPNodeDescriptionViewController ()

@end

@implementation RPNodeDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    lb_desc.text = self.desc;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onReadMore:(id)sender {
    WebViewViewController *viewcontroller = [WebViewViewController initWithNibName];
    [viewcontroller setTitle:self.title];
    [viewcontroller setWebUrl:self.url];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

@end
