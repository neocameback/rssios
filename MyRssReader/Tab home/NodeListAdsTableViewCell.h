//
//  NodeListAdsTableViewCell.h
//  MyRssReader
//
//  Created by Huy on 8/9/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NodeListAdsTableViewCell : UITableViewCell

@property (nonatomic, weak) UIViewController *parentVC;
@property(nonatomic, weak) IBOutlet GADNativeExpressAdView *bannerView;

-(void) setAdUnit:(NSString *) adsID;
@end
