//
//  RssListViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/23/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "RssListViewController.h"
#import "Rss.h"
#import "RssNode.h"
#import "Node.h"
#import "NodeListViewController.h"
#import "MWFeedParser.h"

@interface RssListViewController ()
{
    
    RssManager *manager;
}
@property (nonatomic, strong) NSMutableArray *rssList;
@end

@implementation RssListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Home";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.enableCastFunction = YES;
    CGRect frame = CGRectMake(0, 0, 24, 24);
    GCKUICastButton *castButton = [[GCKUICastButton alloc] initWithFrame:frame];
    castButton.tintColor = kGreenColor;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:castButton];
    self.navigationItem.rightBarButtonItem = item;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onShowSideMenu:)];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.screenName = @"Home View";
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isBookmarkRss == 1"];
        self.rssList = [[NSMutableArray alloc] initWithArray:[Rss MR_findAllSortedBy:@"rssTitle" ascending:YES withPredicate:predicate]];

        [_tableView reloadData];
    }
    else // first time lauche application, we'll save a sample RSS url
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        manager = [[RssManager alloc] initWithRssUrl:[NSURL URLWithString:kDefaultRssUrl]];
        __weak typeof(self) wself = self;
        [manager startParseCompletion:^(RssModel *rssModel, NSMutableArray *nodeList) {
            Rss *defaultRss = [Rss MR_createEntity];
            [defaultRss setIsBookmarkRssValue:YES];
            [defaultRss setCreatedAt:[NSDate date]];
            [defaultRss initFromTempRss:rssModel];
            
            for (RssNodeModel *nodeModel in nodeList) {
                RssNode *node = [RssNode MR_createEntity];
                [node setCreatedAt:[NSDate date]];
                [node initFromTempNode:nodeModel];
                [node setRss:defaultRss];
            }
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
            wself.rssList = [[NSMutableArray alloc] initWithArray:[Rss MR_findAllSortedBy:@"rssTitle" ascending:YES]];
            [wself.tableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)onShowSideMenu:(id)sender {
    switch ([self.mm_drawerController openSide]) {
        case MMDrawerSideLeft:
        {
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                
            }];
        }
            break;
        case MMDrawerSideRight:
            
            break;
            
        default:
        {
            [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
                
            }];
        }
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rssList.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self.rssList[indexPath.row] rssTitle];
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /**
     *  retrieve the cached RSS
     */
    Rss *currentRss = self.rssList[indexPath.row];
    /*
     *  check auto refresh time to fetch new data
     */
    NSInteger autoRefreshTime = [[NSUserDefaults standardUserDefaults] integerForKey:kAutoRefreshNewsTime];
    BOOL needRefresh = NO;
    if (currentRss) {
        NSDate *lastUpdated = [currentRss updatedAt];
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastUpdated];
        if (interval >= autoRefreshTime) {
            needRefresh = YES;
        }else{
            needRefresh = NO;
        }
    }
    if (!currentRss || currentRss.shouldCacheValue == NO || currentRss.nodeList.count <= 0 || needRefresh) {
        
        manager = [[RssManager alloc] initWithRssUrl:[NSURL URLWithString:currentRss.rssLink]];
        __weak typeof(self) wself = self;
        [manager startParseCompletion:^(RssModel *rssModel, NSMutableArray *nodeList) {
            
            [currentRss setUpdatedAt:[NSDate date]];
            [[currentRss nodeListSet] removeAllObjects];
            if (currentRss && currentRss.shouldCacheValue) {
                for (RssNodeModel *nodeModel in nodeList) {
                    RssNode *node = [RssNode MR_createEntity];
                    [node initFromTempNode:nodeModel];
                    [node setCreatedAt:[NSDate date]];
                    [node setRss:currentRss];
                }
            }
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
            
            NodeListViewController *viewcontroller = [NodeListViewController initWithNibName];
            [viewcontroller setNodeList:nodeList];
            [viewcontroller setRssURL:currentRss.rssLink];
            [viewcontroller setTitle:currentRss.rssTitle];
            [wself.navigationController pushViewController:viewcontroller animated:YES];
            
        } failure:^(NSError *error) {
            
        }];
        
    }else{
        NSMutableArray *nodeList = [NSMutableArray array];
        for (RssNode *node in currentRss.nodeList) {
            RssNodeModel *aNode = [[RssNodeModel alloc] initWithRssNode:node];
            [nodeList addObject:aNode];
        }
        
        NodeListViewController *viewcontroller = [NodeListViewController initWithNibName];
        [viewcontroller setNodeList:nodeList];
        [viewcontroller setRssURL:currentRss.rssLink];
        [viewcontroller setTitle:currentRss.rssTitle];
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
}
@end
