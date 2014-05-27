//
//  BookmarkViewController.h
//  MyRssReader
//
//  Created by Huyns89 on 5/23/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MWFeedParser.h>
#import "Rss.h"
@interface BookmarkViewController : UIViewController <MWFeedParserDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *nodeList;
    MWFeedParser *feedParser;
    Rss *newRss;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
