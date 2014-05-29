//
//  BaseViewController.h
//  MyRssReader
//
//  Created by Huyns89 on 5/28/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GADBannerView.h>

@interface BaseViewController : UIViewController
{
    GADBannerView *bannerView_;
}
@property (nonatomic, strong) GADBannerView *bannerView_;
@end
