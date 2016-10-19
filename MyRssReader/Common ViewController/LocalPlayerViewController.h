//
//  LocalPlayerViewController.h
//  MyRssReader
//
//  Created by Huy Nguyen on 10/17/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "BaseViewController.h"
#import "File.h"

@interface LocalPlayerViewController : BaseViewController
{
    __weak IBOutlet UIView *viewSubtitle;
    __weak IBOutlet UILabel *lbSubTitle;
    
    __weak IBOutlet UIStepper *stepper;
}
/**
 *  play video from downloaded list
 */
@property (nonatomic, strong) File *downloadedFile;
@property (nonatomic, strong) NSString *currentSubtitleURL;
@end
