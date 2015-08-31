//
//  RPNodeDescriptionViewController.h
//  MyRssReader
//
//  Created by Huyns89 on 8/25/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPNodeDescriptionViewController : BaseViewController <UITextViewDelegate>
{
    
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet UIButton *btn_readMore;
    __weak IBOutlet UITextView *tv_desc;
    __weak IBOutlet NSLayoutConstraint *descriptionTextViewHeight;
    
}
@property (nonatomic, strong) NSString *desc, *url;
@end
