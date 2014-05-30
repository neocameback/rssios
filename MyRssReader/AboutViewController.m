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
    [bannerView_ loadRequest:[GADRequest request]];
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
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[kDefaultShareTitle] applicationActivities:nil];
    
    NSArray *excludedActivities = nil;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        excludedActivities = @[UIActivityTypePostToTwitter,
                               UIActivityTypePostToWeibo,
                               UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                               UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                               UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                               UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
    }else{
        excludedActivities = @[UIActivityTypePostToTwitter,
                               UIActivityTypePostToWeibo,
                               UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                               UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    }
    controller.excludedActivityTypes = excludedActivities;
    
    [self presentViewController:controller animated:YES completion:nil];
}

@end
