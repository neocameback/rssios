//
//  BaseNodeListViewController.h
//  MyRssReader
//
//  Created by GEM on 6/15/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "BaseViewController.h"
#import "Rss.h"
#import "RssNode.h"
#import "RssModel.h"
#import "RssNodeModel.h"

#import "MWFeedParser.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

typedef void (^ ConfigureTableViewCellBlock) (id cell, id item);

@interface BaseNodeListViewController : BaseViewController <GADInterstitialDelegate> {
    NSArray *searchResults;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *rssTitle; // the rssTitle will be used to set as file name when download with default name
@property (nonatomic, strong) NSMutableArray *nodeList; // nodeList will be used to display in tableView
@property (nonatomic, strong) GADInterstitial *interstitial;
@end
