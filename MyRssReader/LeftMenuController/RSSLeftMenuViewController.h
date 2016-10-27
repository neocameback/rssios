//
//  RSSLeftMenuViewController.h
//  MyRssReader
//
//  Created by Huy Nguyen on 10/21/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    RSSSideMenuHome,
//    RSSSideMenuManage,
    RSSSideMenuFavorite,
    RSSSideMenuDownload,
    RSSSideMenuAbout
} RSSSideMenuIndex;

@interface RSSLeftMenuViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (UINavigationController *)centerViewController;
@end
