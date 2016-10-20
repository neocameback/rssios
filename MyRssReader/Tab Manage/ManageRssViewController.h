//
//  AddNewRssViewController.h
//  MyRssReader
//
//  Created by Huyns89 on 5/23/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
#import "Rss.h"
#import "Node.h"

@interface ManageRssViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, MWFeedParserDelegate>
{
    
    
    NSInteger editingIndex;
}
@property (nonatomic, strong) NSMutableArray *rssList;
@property (nonatomic, strong) Rss *aNewRss;
@property (nonatomic, strong) NSString *aNewRssName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
