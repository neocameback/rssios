//
//  UIPaddingTextField.m
//  MyRssReader
//
//  Created by Huy Nguyen on 11/2/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "UIPaddingTextField.h"

@implementation UIPaddingTextField
// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}
@end
