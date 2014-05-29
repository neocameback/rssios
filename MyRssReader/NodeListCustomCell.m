//
//  NodeListCustomCell.m
//  MyRssReader
//
//  Created by Huyns89 on 5/26/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "NodeListCustomCell.h"
#import <UIImageView+AFNetworking.h>

@implementation NodeListCustomCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) configWithNode:(Node*) node
{
    [self.iv_image setImageWithURL:[NSURL URLWithString:[node nodeImage]] placeholderImage:[UIImage imageNamed:@"default_rss_img"]];
    self.lb_title.text = [node nodeTitle];
    if ([node bookmarkStatus] != nil && ( [[node bookmarkStatus] caseInsensitiveCompare:@"true"] == NSOrderedSame || [[node bookmarkStatus] boolValue] == YES)) {
        self.btn_addToFav.hidden = NO;
        if ([node.isAddedToBoomark boolValue]) {
            self.btn_addToFav.selected = YES;
        }else{
            self.btn_addToFav.selected = NO;
        }
    }else{
        self.btn_addToFav.hidden = YES;
    }
}
@end
