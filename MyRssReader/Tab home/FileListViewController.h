//
//  FileListViewController.h
//  MyRssReader
//
//  Created by Huyns89 on 8/28/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface FileListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray *nodeList;
    NSArray *searchResults;
}
@property (nonatomic, strong) NSString *webPageUrl;
@end
