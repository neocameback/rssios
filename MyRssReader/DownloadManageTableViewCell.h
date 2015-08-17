//
//  DownloadManageTableViewCell.h
//  MyRssReader
//
//  Created by Huyns89 on 8/17/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "File.h"

@interface DownloadManageTableViewCell : UITableViewCell
{
    __weak IBOutlet UILabel *lb_fileName;
    __weak IBOutlet UILabel *lb_progress;
    
}
@property (nonatomic, strong) File *file;

@end
