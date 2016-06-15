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
#import "RssModel.h"
#import "RssNodeModel.h"
#import "BaseNodeListViewController.h"

#import "MWFeedParser.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface NodeListViewController : BaseNodeListViewController <MWFeedParserDelegate>
{
    MWFeedParser *feedParser;    
    Rss *cachedRss;
}
@property (nonatomic, strong) NSString *rssURL;
@end
