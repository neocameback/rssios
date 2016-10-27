//
//  DownloadManageTableViewCell.m
//  MyRssReader
//
//  Created by Huyns89 on 8/17/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import "DownloadManageTableViewCell.h"
#import "UIImageView+AFNetworking.h"

#define MB2B    1000000

@implementation DownloadManageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setFile:(File *)file
{
    [ivThumbnail setImageWithURL:[NSURL URLWithString:file.thumbnail] placeholderImage:[UIImage imageNamed:@"icon_default"]];
    lb_fileName.text = file.name;
    if (file.stateValue == DownloadStateCompleted) {
        lb_progress.text = file.desc;
        coverView.hidden = YES;
        lb_progress.textColor = [UIColor blackColor];
    }else{
        if (file.progressValue <= 0) {
            lb_progress.text = [NSString stringWithFormat:@"Waiting..."];
        }else{
            lb_progress.text = [NSString stringWithFormat:@"Saving: %.0hd%%",file.progressValue];
        }
        coverView.hidden = NO;
        lb_progress.textColor = [UIColor colorWithRed:33.0/255 green:150.0/255 blue:243.0/255 alpha:1];
    }
}
@end
