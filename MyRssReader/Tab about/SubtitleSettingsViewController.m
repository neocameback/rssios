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

@interface SubtitleSettingsViewController () <UITextFieldDelegate>
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
    
    [self updateFontAppearance];
}

- (void) updateFontAppearance {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *fontName = [userDefault objectForKey:kSubtitleFont];
    NSString *textColor = [userDefault objectForKey:kSubtitleTextColor];
    NSInteger fontSize = [userDefault integerForKey:kSubtitleTextSize];
    NSString *backgroundColor = [userDefault objectForKey:kSubtitleBackgroundColor];
    CGFloat opacity = [userDefault floatForKey:kSubtitleOpacity];
    [self.fontButton setTitle:fontName forState:UIControlStateNormal];
    [self.fontButton.titleLabel setFont:[UIFont fontWithName:fontName size:15]];
    [self.textColorButton setBackgroundColor:[UIColor colorWithHexString:textColor]];
    [self.textSizeTextField setText:[NSString stringWithFormat:@"%d",(int)fontSize]];
    [self.backgroundColorButton setBackgroundColor:[UIColor colorWithHexString:backgroundColor]];
    [self.opacityTextField setText:[NSString stringWithFormat:@"%.1f",opacity]];
    
    [self updateSubtitleLabel];
}

- (void)updateSubtitleLabel {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *fontName = [userDefault objectForKey:kSubtitleFont];
    NSString *textColor = [userDefault objectForKey:kSubtitleTextColor];
    NSInteger fontSize = [userDefault integerForKey:kSubtitleTextSize];
    NSString *backgroundColor = [userDefault objectForKey:kSubtitleBackgroundColor];
    CGFloat opacity = [userDefault floatForKey:kSubtitleOpacity];
    
    self.subtitleLabel.font = [UIFont fontWithName:fontName size:fontSize];
    self.subtitleLabel.textColor = [UIColor colorWithHexString:textColor];
    self.subtitleLabel.backgroundColor = [UIColor colorWithHexString:backgroundColor opacity:opacity/100];
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
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *fontName = [userDefault objectForKey:kSubtitleFont];
    HODropdownPopoverView *dropdowm = [[HODropdownPopoverView alloc] initWithStrings:arrayListFont selectedString:fontName preferSize:CGSizeZero completion:^(id item, NSInteger index) {
        [userDefault setObject:item forKey:kSubtitleFont];
        [userDefault synchronize];
        [wself updateSubtitleLabel];
        [[wself popover] dismissPopoverAnimated:YES];
    }];
    _popover = [[WYPopoverController alloc] initWithContentViewController:dropdowm];
    [_popover presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES options:WYPopoverAnimationOptionFade];
}

- (IBAction)onSelectTextColor:(id)sender {
    ColorPickerViewController *colorPickerView = [[ColorPickerViewController alloc] init];
    [colorPickerView setColor:[UIColor whiteColor]];
    __weak typeof(self) wself = self;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [colorPickerView setColorPickedBlock:^(id sender, NSString *hexa) {
        NSLog(@"hexa");
        [userDefault setObject:hexa forKey:kSubtitleTextColor];
        [userDefault synchronize];
        [wself updateSubtitleLabel];
        [[wself popover] dismissPopoverAnimated:YES];
    }];
    _popover = [[WYPopoverController alloc] initWithContentViewController:colorPickerView];
    [_popover presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES options:WYPopoverAnimationOptionFade];
}

- (IBAction)onSelectBackgroundColor:(id)sender {
    ColorPickerViewController *colorPickerView = [[ColorPickerViewController alloc] init];
    [colorPickerView setColor:[UIColor whiteColor]];
    __weak typeof(self) wself = self;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [colorPickerView setColorPickedBlock:^(id sender, NSString *hexa) {
        NSLog(@"hexa");
        [userDefault setObject:hexa forKey:kSubtitleBackgroundColor];
        [userDefault synchronize];
        [wself updateSubtitleLabel];
        [[wself popover] dismissPopoverAnimated:YES];
    }];
    _popover = [[WYPopoverController alloc] initWithContentViewController:colorPickerView];
    [_popover presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES options:WYPopoverAnimationOptionFade];
}

- (IBAction)onResetDefault:(id)sender {
    [APPDELEGATE resetToDefaultValues];
    [self updateFontAppearance];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    @try {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if (textField == self.textSizeTextField) {
            NSInteger textsize = [textField.text integerValue];
            [userDefault setInteger:textsize forKey:kSubtitleTextSize];
            [userDefault synchronize];
            [self updateSubtitleLabel];
        } else if (textField == self.opacityTextField) {
            CGFloat opacity = [textField.text floatValue];
            [userDefault setFloat:opacity forKey:kSubtitleOpacity];
            [userDefault synchronize];
            [self updateSubtitleLabel];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        return YES;
    }
}

@end
