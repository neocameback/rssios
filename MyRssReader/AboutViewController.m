//
//  AboutViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/27/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "AboutViewController.h"
#import "WebViewViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"About";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"About View";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onAboutus:(id)sender {
    WebViewViewController *vc = [WebViewViewController initWithNibName];
    [vc setTitle:@"About us"];
    [vc setWebUrl:kAboutUrl];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onShare:(id)sender {
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[kDefaultShareTitle,[NSURL URLWithString:@"http://rssvideoplayer.com"]] applicationActivities:nil];
    
    NSArray *excludedActivities = nil;
    
    controller.excludedActivityTypes = excludedActivities;
    if ([UIPopoverPresentationController class] != nil) {
        UIPopoverPresentationController *popover = controller.popoverPresentationController;
        if (popover)
        {
            popover.sourceView = self.view;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
    }
    
    [self presentViewController:controller animated:YES completion:nil];
}

@end
