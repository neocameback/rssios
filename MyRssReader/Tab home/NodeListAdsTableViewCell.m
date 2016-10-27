//
//  NodeListAdsTableViewCell.m
//  MyRssReader
//
//  Created by Huy on 8/9/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "NodeListAdsTableViewCell.h"

@implementation NodeListAdsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setAdUnit:(NSString *) adsID
{
    [_bannerView setAdSize:kGADAdSizeBanner];
    _bannerView.adUnitID = adsID;
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    _bannerView.rootViewController = _parentVC;
    
    GADRequest *request = [GADRequest request];
    [_bannerView loadRequest:request];
}

@end
