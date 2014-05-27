//
//  NodeListViewController.h
//  MyRssReader
//
//  Created by Huyns89 on 5/26/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rss.h"
#import <MWFeedParser.h>
@interface NodeListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource , MWFeedParserDelegate>
{
    MWFeedParser *feedParser;
    Rss *newRss;
}
@property (nonatomic, strong) Rss *currentRss;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
