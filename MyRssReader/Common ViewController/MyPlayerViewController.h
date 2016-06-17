//
//  MyPlayerViewController.h
//  MyRssReader
//
//  Created by GEM on 6/17/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "BaseViewController.h"
#import "MyCustomerPlayer.h"
#import "ASBPlayerSubtitling.h"

@interface MyPlayerViewController : BaseViewController
{
    __weak IBOutlet UIView *viewSubtitle;
    __weak IBOutlet UILabel *lbSubTitle;
    
    __weak IBOutlet UIStepper *stepper;
}
@property (strong, nonatomic) IBOutlet ASBPlayerSubtitling *subtitling;


@property (nonatomic, strong) RssNodeModel *currentNode;
@property (nonatomic, strong) MyCustomerPlayer *myPlayer;
@end
