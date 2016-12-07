//
//  NodeListViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/26/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "NodeListViewController.h"
#import "Node.h"
#import "UIImageView+AFNetworking.h"
#import "NodeListCustomCell.h"
#import "EmptyNodeTableViewCell.h"
#import "WebViewViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "XCDYouTubeVideoPlayerViewController.h"
#import "DMPlayerViewController.h"
#import "PureLayout.h"
#import "AFNetworking.h"
#import "AFDownloadRequestOperation.h"
#import "MBProgressHUD.h"
#import "DownloadManager.h"
#import "NSString+HTML.h"
#import "RPNodeDescriptionViewController.h"

@interface NodeListViewController () <UIAlertViewDelegate> {
    
}
@property (nonatomic, strong) RssManager *manager;
@property (nonatomic) BOOL isDataLoaded;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end
@implementation NodeListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadDataSource)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
    /**
     *  retrieve the cached RSS
     */
    Rss *cachedRss = [Rss MR_findFirstByAttribute:@"rssLink"
                                                withValue:self.rssURL];
    /*
     *  check auto refresh time to fetch new data
     */
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger autoRefreshTime = [userDefault integerForKey:kAutoRefreshNewsTime];
    BOOL needRefresh = NO;
    if (cachedRss) {
        NSDate *lastUpdated = [cachedRss updatedAt];
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastUpdated];
        if (interval >= autoRefreshTime) {
            needRefresh = YES;
        }else{
            needRefresh = NO;
        }
    }
    if (!cachedRss || cachedRss.shouldCacheValue == NO || cachedRss.nodeList.count <= 0 || needRefresh) {
        [self reloadDataSource];
    } else {
        self.isDataLoaded = YES;
        NSMutableArray *nodeList = [NSMutableArray array];
        for (RssNode *node in cachedRss.nodeList) {
            RssNodeModel *aNode = [[RssNodeModel alloc] initWithRssNode:node];
            [nodeList addObject:aNode];
        }
        self.nodeList = nodeList;
        [self.tableView reloadData];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Item List View";
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Save ManagedObjectContext using MagicalRecord
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)reloadDataSource {
    [self parseRssFromURL:self.rssURL];
}
- (void)parseRssFromURL:(NSString *)url {
    if (!_manager) {
        _manager = [[RssManager alloc] initWithRssUrl:[NSURL URLWithString:url]];
    }
    __weak typeof(self) wself = self;
    [_manager startParseCompletion:^(RssModel *rssModel, NSMutableArray *nodeList) {
        wself.isDataLoaded = YES;
        /**
         *  the saved RSS can have an other name that's enter on manage RSS view
         */
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        Rss *cachedRss = [Rss MR_findFirstByAttribute:@"rssLink"
                                            withValue:wself.rssURL
                                            inContext:context];
        if (cachedRss && cachedRss.rssTitle.length > 0) {
            [rssModel setRssTitle:cachedRss.rssTitle];
        }
        /**
         *  check if this rss should be cache or not
         */
        if (rssModel.shouldCache) {
            if (!cachedRss) {
                cachedRss = [Rss MR_createEntity];
                [cachedRss setCreatedAt:[NSDate date]];
            }else {
                [[cachedRss nodeListSet] removeAllObjects];
            }
            if (!cachedRss.isBookmarkRssValue) {
                [cachedRss setIsBookmarkRssValue:NO];
            }
            [cachedRss initFromTempRss:rssModel];
        }
        
        wself.nodeList = nodeList;
        /**
         *  if this rss should be cache so create new RssNode entity
         */
        if (cachedRss.shouldCacheValue) {
            for (RssNodeModel *nodeModel in nodeList) {
                RssNode *node = [RssNode MR_createEntity];
                [node initFromTempNode:nodeModel];
                [node setCreatedAt:[NSDate date]];
                [node setRss:cachedRss];
            }
        }
        
        [wself.refreshControl endRefreshing];
        [context MR_saveToPersistentStoreWithCompletion:nil];
        [wself.tableView reloadData];
    } failure:^(NSError *error) {
        [wself.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)cellIdentifier {
    return NSStringFromClass([NodeListCustomCell class]);
}

- (ConfigureTableViewCellBlock)configureCellBlock {
    ConfigureTableViewCellBlock configureCellBlock =
        ^(NodeListCustomCell *cell, RssNodeModel *nodeModel){
        [cell configWithNode:nodeModel];
    };
    return configureCellBlock;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isDataLoaded) {
        return [super tableView:tableView numberOfRowsInSection:section];
    } else {
        return 5;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isDataLoaded) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        EmptyNodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyNodeTableViewCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"EmptyNodeTableViewCell" owner:self options:nil].firstObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isDataLoaded) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        /// don't do anything
        /// just holder cells
    }
}

-(void) dealloc {
    
}
@end
