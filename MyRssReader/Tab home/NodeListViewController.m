//
//  NodeListViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/26/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "NodeListViewController.h"
#import "Node.h"
#import <UIImageView+AFNetworking.h>
#import "NodeListCustomCell.h"
#import "WebViewViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <XCDYouTubeVideoPlayerViewController.h>
#import <DMPlayerViewController.h>
#import "MyMoviePlayerViewController.h"
#import <PureLayout.h>
#import <AFNetworking.h>
#import <AFDownloadRequestOperation.h>
#import <MBProgressHUD.h>
#import "DownloadManager.h"
#import "NSString+HTML.h"
#import "RPNodeDescriptionViewController.h"
#import "FileListViewController.h"

@interface NodeListViewController () <UIAlertViewDelegate>
{
    MPMoviePlayerViewController *moviePlayer;
    NodeListCustomCell *nodeCell;
    NSString *identifier;
    NSInteger willDownloadAtIndex;
    
    RssManager *manager;
}
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    /**
//     *  retrieve the cached RSS
//     */
//    cachedRss = [Rss MR_findFirstByAttribute:@"rssLink" withValue:self.rssURL];
//    /*
//     *  check auto refresh time to fetch new data
//     */
//    NSInteger autoRefreshTime = [[NSUserDefaults standardUserDefaults] integerForKey:kAutoRefreshNewsTime];
//    BOOL needRefresh = NO;
//    if (cachedRss) {
//        NSDate *lastUpdated = [cachedRss updatedAt];
//        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastUpdated];
//        if (interval >= autoRefreshTime) {
//            needRefresh = YES;
//        }else{
//            needRefresh = NO;
//        }
//    }
//    if (!cachedRss || cachedRss.shouldCacheValue == NO || cachedRss.nodeList.count <= 0 || needRefresh) {
//        [self parseRssFromURL:self.rssURL];
//    }else{
//        if (!self.nodeList) {
//            self.nodeList = [NSMutableArray array];
//        }
//        for (RssNode *node in cachedRss.nodeList) {
//            RssNodeModel *aNode = [[RssNodeModel alloc] initWithRssNode:node];
//            [self.nodeList addObject:aNode];
//        }
//    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadDataSource)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"Item List View";
    [self.tableView reloadData];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Save ManagedObjectContext using MagicalRecord
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
-(void) reloadDataSource
{
    [self parseRssFromURL:self.rssURL];
}
-(void) parseRssFromURL:(NSString *) url
{
    manager = [[RssManager alloc] initWithRssUrl:[NSURL URLWithString:url]];
    [manager startParseCompletion:^(RssModel *rssModel, NSMutableArray *nodeList) {
        /**
         *  the saved RSS can have an other name that's enter on manage RSS view
         */
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
        
        self.nodeList = nodeList;
        /**
         *  if this rss should be cache so create new RssNode entity
         */
        if (cachedRss && cachedRss.shouldCacheValue) {
            for (RssNodeModel *nodeModel in nodeList) {
                RssNode *node = [RssNode MR_createEntity];
                [node initFromTempNode:nodeModel];
                [node setCreatedAt:[NSDate date]];
                [node setRss:cachedRss];
            }
        }
        
        [self.refreshControl endRefreshing];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            [self.tableView reloadData];
        }];
    } failure:^(NSError *error) {
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *) cellIdentifier
{
    return NSStringFromClass([NodeListCustomCell class]);
}

-(ConfigureTableViewCellBlock) configureCellBlock
{
    ConfigureTableViewCellBlock configureCellBlock = ^(NodeListCustomCell *cell, RssNodeModel *nodeModel){
        [cell configWithNode:nodeModel];
    };
    return configureCellBlock;
}

-(void) onDownLoad:(id) sender
{
    willDownloadAtIndex = [sender tag];
    /**
     *     let user enter the file name will be saved
     */
    [self showAlertEnterFileName];
}
-(void) showAlertEnterFileName
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download video" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Download", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setPlaceholder:@"Put file name here."];
    [[alert textFieldAtIndex:0] setClearButtonMode:UITextFieldViewModeWhileEditing];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [label setText:@"*"];
    [label setTextColor:[UIColor redColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [[alert textFieldAtIndex:0] setRightViewMode:UITextFieldViewModeAlways];
    [[alert textFieldAtIndex:0] setRightView:label];
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeASCIICapable];
    [[alert textFieldAtIndex:0] setClearButtonMode:UITextFieldViewModeWhileEditing];
    [alert setTag:ALERT_ENTER_FILE_NAME];
    [alert show];
}

#pragma mark uialertview delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case ALERT_ENTER_FILE_NAME:
        {
            if (buttonIndex != alertView.cancelButtonIndex) {
                NSString *videoUrl = [self.nodeList[willDownloadAtIndex] nodeUrl];
                [[DownloadManager shareManager] downloadFile:videoUrl name:[[alertView textFieldAtIndex:0] text] fromView:self];
            }
        }
            break;
            
        case ALERT_NAME_EXIST:
        {
            if (buttonIndex != alertView.cancelButtonIndex) {
                [self showAlertEnterFileName];
            }
        }
            break;
        default:
            break;
    }
}
-(void) dealloc
{
    moviePlayer = nil;
    nodeCell = nil;
}
@end
