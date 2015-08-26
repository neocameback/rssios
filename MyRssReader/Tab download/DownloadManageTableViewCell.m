//
//  DownloadManageTableViewCell.m
//  MyRssReader
//
//  Created by Huyns89 on 8/17/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import "DownloadManageTableViewCell.h"

#define MB2B    1000000

@implementation DownloadManageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setFile:(File *)file
{
    lb_fileName.text = file.name;
    if (file.isCompletedValue) {
        lb_progress.text = @"Download Completed";
    }else{
        lb_progress.text = [NSString stringWithFormat:@"%.2f%%(%.2fMB/%.2fMB)",file.downloadedBytesValue/file.expectedBytesValue*100, file.downloadedBytesValue/MB2B, file.expectedBytesValue/MB2B];
    }
}
@end
