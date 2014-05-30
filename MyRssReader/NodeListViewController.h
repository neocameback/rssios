//
//  NodeListViewController.h
//  MyRssReader
//
//  Created by Huyns89 on 5/26/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rss.h"
#import "TempRss.h"
#import "TempNode.h"

#import <MWFeedParser.h>
#import <GADInterstitial.h>

typedef enum : NSUInteger {
    CELL_TYPE_NORMAL,
    CELL_TYPE_AD,
} CELL_TYPE;

@interface NodeListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource , MWFeedParserDelegate, GADInterstitialDelegate>
{
    MWFeedParser *feedParser;
    TempRss *tempRss;
    NSMutableArray *nodeList;
    
    GADInterstitial *interstitial_;
    
    NSIndexPath *currentPath;
}
@property (nonatomic, strong) Rss *currentRss;
@property (nonatomic, strong) TempRss *tempRss;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
