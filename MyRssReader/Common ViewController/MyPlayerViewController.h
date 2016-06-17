//
//  MyPlayerViewController.h
//  MyRssReader
//
//  Created by GEM on 6/17/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "BaseViewController.h"
#import "MyCustomerPlayer.h"

@interface MyPlayerViewController : BaseViewController

@property (nonatomic, strong) RssNodeModel *currentNode;
@property (nonatomic, strong) MyCustomerPlayer *myPlayer;
@end
