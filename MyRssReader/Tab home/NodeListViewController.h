//
//  NodeListViewController.h
//  MyRssReader
//
//  Created by Huyns89 on 5/26/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rss.h"
#import "RssNode.h"
#import "TempRss.h"
#import "TempNode.h"

#import "MWFeedParser.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface NodeListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource , MWFeedParserDelegate, GADInterstitialDelegate>
{
    MWFeedParser *feedParser;
    
    GADInterstitial *interstitial_;
    
    TempNode *currentNode;
    NSMutableArray *nodeList;
    NSArray *searchResults;
    TempRss *tempRss;
    Rss *cachedRss;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *rssURL;
@end
