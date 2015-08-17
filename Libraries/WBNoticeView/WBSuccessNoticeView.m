//
//  WBSuccessNoticeView.m
//  NoticeView
//
//  Created by Tito Ciuro on 5/25/12.
//  Copyright (c) 2012 Tito Ciuro. All rights reserved.
//

#import "WBSuccessNoticeView.h"
#import "WBNoticeView+ForSubclassEyesOnly.h"
#import "WBBlueGradientView.h"

@implementation WBSuccessNoticeView

+ (WBSuccessNoticeView *)successNoticeInView:(UIView *)view title:(NSString *)title duration:(CGFloat) duration alpha:(CGFloat) alpha delay:(CGFloat) delay
{
    WBSuccessNoticeView *notice = [[WBSuccessNoticeView alloc]initWithView:view title:title duration:duration alpha:alpha delay:delay];
    
    notice.sticky = NO;
    
    return notice;
}
+ (WBSuccessNoticeView *)successNoticeInView:(UIView *)view title:(NSString *)title
{
    WBSuccessNoticeView *notice = [[WBSuccessNoticeView alloc]initWithView:view title:title];

    notice.sticky = NO;

    return notice;
}

- (void)showSuccess
{
    // Obtain the screen width
    CGFloat viewWidth = self.view.bounds.size.width;
    
    NSInteger numberOfLines = 1;
    CGFloat messageLineHeight = 35.0;
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    // Make and add the title label
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(56, statusBarHeight + 10, viewWidth - 70, messageLineHeight)];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel setNumberOfLines:2];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.title;
    
    // Calculate the notice view height
    float noticeViewHeight = 45.0 + statusBarHeight;
    if (numberOfLines > 1) {
        noticeViewHeight += (numberOfLines - 1) * messageLineHeight;
    }
    
    // Make sure we hide completely the view, including its shadow
    float hiddenYOrigin = self.slidingMode == WBNoticeViewSlidingModeDown ? -noticeViewHeight - 20.0: self.view.bounds.size.height;
    
    // Make and add the notice view
    self.gradientView = [[WBBlueGradientView alloc] initWithFrame:CGRectMake(0.0, hiddenYOrigin, viewWidth, noticeViewHeight + 10.0)];
    [self.view addSubview:self.gradientView];
    
    // Make and add the icon view
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, statusBarHeight + 10.0, 36.0, 35.0)];
    iconView.image = [UIImage imageNamed:@"notice_success_icon"];
    iconView.alpha = 1;
    [self.gradientView addSubview:iconView];
    
    // Add the title label
    [self.gradientView addSubview:self.titleLabel];
    
    // Add the drop shadow to the notice view
    CALayer *noticeLayer = self.gradientView.layer;
    noticeLayer.shadowColor = [[UIColor blackColor]CGColor];
    noticeLayer.shadowOffset = CGSizeMake(0.0, 0.0);
    noticeLayer.shadowOpacity = 0.30;
    noticeLayer.masksToBounds = NO;
    noticeLayer.shouldRasterize = YES;
    
    self.hiddenYOrigin = hiddenYOrigin;
    
    [self displayNotice];
}

-(void) showFailure
{
    // Obtain the screen width
    CGFloat viewWidth = self.view.bounds.size.width;
    
    NSInteger numberOfLines = 1;
    CGFloat messageLineHeight = 35.0;
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    // Make and add the title label
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(56, statusBarHeight + 10, viewWidth - 70, messageLineHeight)];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel setNumberOfLines:2];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.title;
    
    // Calculate the notice view height
    float noticeViewHeight = 45.0 + statusBarHeight;
    if (numberOfLines > 1) {
        noticeViewHeight += (numberOfLines - 1) * messageLineHeight;
    }
    
    // Make sure we hide completely the view, including its shadow
    float hiddenYOrigin = self.slidingMode == WBNoticeViewSlidingModeDown ? -noticeViewHeight - 20.0: self.view.bounds.size.height;
    
    // Make and add the notice view
    self.gradientView = [[WBBlueGradientView alloc] initWithFrame:CGRectMake(0.0, hiddenYOrigin, viewWidth, noticeViewHeight + 10.0)];
    [self.view addSubview:self.gradientView];
    
    // Make and add the icon view
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, statusBarHeight + 10.0, 36.0, 35.0)];
    iconView.image = [UIImage imageNamed:@"notice_error_icon"];
    iconView.alpha = 1;
    [self.gradientView addSubview:iconView];
    
    // Add the title label
    [self.gradientView addSubview:self.titleLabel];
    
    // Add the drop shadow to the notice view
    CALayer *noticeLayer = self.gradientView.layer;
    noticeLayer.shadowColor = [[UIColor blackColor]CGColor];
    noticeLayer.shadowOffset = CGSizeMake(0.0, 0.0);
    noticeLayer.shadowOpacity = 0.30;
    noticeLayer.masksToBounds = NO;
    noticeLayer.shouldRasterize = YES;
    
    self.hiddenYOrigin = hiddenYOrigin;
    
    [self displayNotice];
}
@end
