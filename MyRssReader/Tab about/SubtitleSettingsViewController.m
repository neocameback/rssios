//
//  SubtitleSettingsViewController.m
//  MyRssReader
//
//  Created by Huy Nguyen on 11/2/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "SubtitleSettingsViewController.h"
#import <WYPopoverController/WYPopoverController.h>
#import "ColorPickerViewController.h"
#import "HODropdownPopoverView.h"

@interface SubtitleSettingsViewController ()
@property (nonatomic, strong) WYPopoverController *popover;
@end

@implementation SubtitleSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Subtitle appearance";
    [self setupView];
}

- (void)setupView {
    UIColor *borderColor = [UIColor colorWithHexString:kBorderColor];
    self.fontButton.layer.borderWidth = 1;
    self.fontButton.layer.borderColor = borderColor.CGColor;
    
    self.textColorButton.layer.borderWidth = 1;
    self.textColorButton.layer.borderColor = borderColor.CGColor;
    
    self.textSizeTextField.layer.borderWidth = 1;
    self.textSizeTextField.layer.borderColor = borderColor.CGColor;
    
    self.opacityTextField.layer.borderWidth = 1;
    self.opacityTextField.layer.borderColor = borderColor.CGColor;
    
    self.backgroundColorButton.layer.borderWidth = 1;
    self.backgroundColorButton.layer.borderColor = borderColor.CGColor;    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSelectFont:(id)sender {
    NSMutableArray *arrayListFont = [[NSMutableArray alloc] init];
    [arrayListFont addObject:@"AvenirNext-Regular"];
    [arrayListFont addObject:@"Arial"];
    [arrayListFont addObject:@"Baskerville"];
    [arrayListFont addObject:@"Georgia"];
    [arrayListFont addObject:@"Helvetica"];
    [arrayListFont addObject:@"Palatino"];
    [arrayListFont addObject:@"Verdana"];
    __weak typeof(self) wself = self;
    HODropdownPopoverView *dropdowm = [[HODropdownPopoverView alloc] initWithStrings:arrayListFont selectedString:@"Arial" preferSize:CGSizeZero completion:^(id item, NSInteger index) {
        [[wself popover] dismissPopoverAnimated:YES];
    }];
    _popover = [[WYPopoverController alloc] initWithContentViewController:dropdowm];
    [_popover presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES options:WYPopoverAnimationOptionFade];
}

- (IBAction)onSelectTextColor:(id)sender {
    ColorPickerViewController *colorPickerView = [[ColorPickerViewController alloc] init];
    [colorPickerView setColor:[UIColor whiteColor]];
    __weak typeof(self) wself = self;
    [colorPickerView setColorPickedBlock:^(id sender, NSString *hexa) {
        NSLog(@"hexa");
        [[wself popover] dismissPopoverAnimated:YES];
    }];
    _popover = [[WYPopoverController alloc] initWithContentViewController:colorPickerView];
    [_popover presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES options:WYPopoverAnimationOptionFade];
}

- (IBAction)onSelectFontSmall:(id)sender {
}

- (IBAction)onSelectFontMedium:(id)sender {
}

- (IBAction)onSelectFontLarge:(id)sender {
}

- (IBAction)onSelectBackgroundColor:(id)sender {
}

- (IBAction)onSelectWindowColor:(id)sender {
}

- (IBAction)onSave:(id)sender {
}

- (IBAction)onResetDefault:(id)sender {
}

@end
