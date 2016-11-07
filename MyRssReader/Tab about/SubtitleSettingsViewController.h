//
//  SubtitleSettingsViewController.h
//  MyRssReader
//
//  Created by Huy Nguyen on 11/2/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "BaseViewController.h"
#import "UIPaddingTextField.h"

@interface SubtitleSettingsViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *fontButton;
@property (weak, nonatomic) IBOutlet UIButton *textColorButton;
@property (weak, nonatomic) IBOutlet UIPaddingTextField *textSizeTextField;
@property (weak, nonatomic) IBOutlet UIPaddingTextField *opacityTextField;
@property (weak, nonatomic) IBOutlet UIButton *backgroundColorButton;

- (IBAction)onSelectFont:(id)sender;
- (IBAction)onSelectTextColor:(id)sender;
- (IBAction)onSelectBackgroundColor:(id)sender;

- (IBAction)onResetDefault:(id)sender;
@end
