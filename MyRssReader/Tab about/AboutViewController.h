//
//  AboutViewController.h
//  MyRssReader
//
//  Created by Huyns89 on 5/27/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    
}
@end
