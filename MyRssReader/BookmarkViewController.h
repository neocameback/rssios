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
#import <GADInterstitial.h>
@interface BookmarkViewController : BaseViewController <MWFeedParserDelegate, UITableViewDataSource, UITableViewDelegate,GADInterstitialDelegate, UISearchDisplayDelegate>
{
    NSMutableArray *nodeList;
    NSMutableArray *searchResults;
    MWFeedParser *feedParser;
    Rss *newRss;
    GADInterstitial *interstitial_;
    NSIndexPath *currentPath;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
