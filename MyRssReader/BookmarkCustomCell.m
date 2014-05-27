//
//  BookmarkCustomCell.m
//  MyRssReader
//
//  Created by Huyns89 on 5/27/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "BookmarkCustomCell.h"
#import <UIImageView+AFNetworking.h>

@implementation BookmarkCustomCell

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
}

@end
