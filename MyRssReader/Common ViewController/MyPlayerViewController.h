//
//  MyPlayerViewController.h
//  MyRssReader
//
//  Created by GEM on 6/17/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "BaseViewController.h"
#import "File.h"

@interface MyPlayerViewController : BaseViewController
{
    __weak IBOutlet UIView *viewSubtitle;
    __weak IBOutlet UILabel *lbSubTitle;
    
    __weak IBOutlet UIStepper *stepper;
}
/**
 *  play video from node list
 */
@property (nonatomic, strong) RssNodeModel *currentNode;
@property (nonatomic, strong) NSString *currentSubtitleURL;

/**
 *  play video from downloaded list
 */
@property (nonatomic, strong) File *downloadedFile;
@end
