//
//  BookmarkViewController.h
//  MyRssReader
//
//  Created by Huyns89 on 5/23/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
#import "Rss.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
@interface BookmarkViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>
{
    NSMutableArray *nodeList;
    NSMutableArray *searchResults;
    MWFeedParser *feedParser;
    Rss *newRss;
    NSIndexPath *currentPath;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
