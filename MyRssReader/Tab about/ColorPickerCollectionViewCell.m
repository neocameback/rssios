//
//  ColorPickerCollectionViewCell.m
//  MyRssReader
//
//  Created by Huy Nguyen on 11/4/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "ColorPickerCollectionViewCell.h"

@implementation ColorPickerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.colorView.layer.borderWidth = 1.0;
    self.colorView.layer.borderColor = [UIColor colorWithHexString:kBorderColor].CGColor;
}

@end
