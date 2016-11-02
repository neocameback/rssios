//
//  SubtitleSettingsViewController.m
//  MyRssReader
//
//  Created by Huy Nguyen on 11/2/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "SubtitleSettingsViewController.h"

@interface SubtitleSettingsViewController ()

@end

@implementation SubtitleSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Subtitle appearance";
    [self setupView];
}

- (void)setupView {
    UIColor *borderColor = [UIColor colorWithHexString:@"b3b3b3"];
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
}

- (IBAction)onSelectTextColor:(id)sender {
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
