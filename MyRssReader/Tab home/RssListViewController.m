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

@interface RssListViewController () {
    RssManager *manager;
    NSInteger editingIndex;
}
@property (nonatomic, strong) NSMutableArray *rssList;
@end

@implementation RssListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Channels";
    }
    return self;
}

#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView setAllowsSelectionDuringEditing:YES];
    
    self.enableCastFunction = YES;
    CGRect frame = CGRectMake(0, 0, 24, 24);
    GCKUICastButton *castButton = [[GCKUICastButton alloc] initWithFrame:frame];
    castButton.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEdit)];
    UIBarButtonItem *castBarButton = [[UIBarButtonItem alloc] initWithCustomView:castButton];
    self.navigationItem.rightBarButtonItems = @[editButton, castBarButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onShowSideMenu:)];
    editingIndex = -1;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.screenName = @"Channels View";
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [self reloadRssList];
    } else {// first time lauche application, we'll save a sample RSS url
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

- (void)reloadRssList {
    self.rssList = [[NSMutableArray alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isBookmarkRss == 1"];
    self.rssList = [[NSMutableArray alloc] initWithArray:[Rss MR_findAllSortedBy:@"rssTitle" ascending:YES withPredicate:predicate]];
    [_tableView reloadData];
}



#pragma mark IBActions
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

-(void) onEdit
{
    if (_tableView.editing) {
        _tableView.editing = NO;
    }else{
        _tableView.editing = YES;
    }
}

- (IBAction)onAddNewChannel:(id)sender {
    _tableView.editing = NO;
    editingIndex = -1;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Channel" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [[alert textFieldAtIndex:0] setPlaceholder:@"Put rss name here."];
    [[alert textFieldAtIndex:0] setClearButtonMode:UITextFieldViewModeWhileEditing];
    [[alert textFieldAtIndex:1] setPlaceholder:@"Put rss link here."];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [label setText:@"*"];
    [label setTextColor:[UIColor redColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [[alert textFieldAtIndex:1] setRightViewMode:UITextFieldViewModeAlways];
    [[alert textFieldAtIndex:1] setRightView:label];
    [[alert textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeURL];
    [[alert textFieldAtIndex:1] setClearButtonMode:UITextFieldViewModeWhileEditing];
    [[alert textFieldAtIndex:1] setSecureTextEntry:NO];
    [alert show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rssList.count;
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

#pragma mark UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /**
     *  retrieve the cached RSS
     */
    Rss *currentRss = self.rssList[indexPath.row];
    
    /*
     *  if tableView isEditing, so display Promt for user to edit the RSS Channel
     */
    if (tableView.isEditing) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit Channel" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
        [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        [[alert textFieldAtIndex:0] setPlaceholder:@"Put rss name here."];
        [[alert textFieldAtIndex:0] setClearButtonMode:UITextFieldViewModeWhileEditing];
        [[alert textFieldAtIndex:0] setText:currentRss.rssTitle];
        [[alert textFieldAtIndex:1] setPlaceholder:@"Put rss link here."];
        [[alert textFieldAtIndex:1] setText:currentRss.rssLink];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [label setText:@"*"];
        [label setTextColor:[UIColor redColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [[alert textFieldAtIndex:1] setRightViewMode:UITextFieldViewModeAlways];
        [[alert textFieldAtIndex:1] setRightView:label];
        [[alert textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeURL];
        [[alert textFieldAtIndex:1] setClearButtonMode:UITextFieldViewModeWhileEditing];
        [[alert textFieldAtIndex:1] setSecureTextEntry:NO];
        [alert show];
    } else {
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
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Rss *aRss = self.rssList[indexPath.row];
    [aRss MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    [self.rssList removeObjectAtIndex:indexPath.row];
    
    [_tableView reloadData];
}

#pragma mark UIAlertView delegate
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if ([[[alertView textFieldAtIndex:1] text] length] > 0) {
        return YES;
    }else{
        return NO;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            editingIndex = -1;
        }
            break;
        default:
        {
            /**
             *   check if user are on editing mode
             */
            
            /// clear the old RSS
            if (editingIndex >= 0) {
                Rss *rss = self.rssList[editingIndex];
                [rss MR_deleteEntity];
                [self.rssList removeObjectAtIndex:editingIndex];
                editingIndex = -1;
            }
            
            /// replace with a new one
            NSString *newRssName = [[alertView textFieldAtIndex:0] text];
            NSString *urlString = [[alertView textFieldAtIndex:1] text];
            BOOL result = [[urlString lowercaseString] hasPrefix:@"http://"];
            if (!result) {
                urlString = [NSString stringWithFormat:@"http://%@", urlString];
            }
            
            manager = [[RssManager alloc] initWithRssUrl:[NSURL URLWithString:urlString]];
            __weak typeof(self) wself = self;
            [manager startParseCompletion:^(RssModel *rssModel, NSMutableArray *nodeList) {
                /**
                 *  save the new RSS
                 */
                Rss *aNewRss = [Rss MR_findFirstByAttribute:@"rssLink" withValue:rssModel.rssLink];
                if (!aNewRss) {
                    aNewRss = [Rss MR_createEntity];
                }
                [[aNewRss nodeListSet] removeAllObjects];
                if (rssModel.shouldCache) {
                    aNewRss.shouldCacheValue = YES;
                }else{
                    aNewRss.shouldCacheValue = NO;
                }
                [aNewRss setIsBookmarkRssValue:YES];
                [aNewRss setCreatedAt:[NSDate date]];
                [aNewRss setUpdatedAt:[NSDate date]];
                if (newRssName && newRssName.length > 0) {
                    aNewRss.rssTitle = newRssName;
                }else{
                    aNewRss.rssTitle = rssModel.rssTitle;
                }
                
                aNewRss.rssLink = rssModel.rssLink;
                
                /**
                 *  if this rss should be cache so create new RssNode entity
                 */
                if (aNewRss && aNewRss.shouldCacheValue) {
                    for (RssNodeModel *nodeModel in nodeList) {
                        RssNode *node = [RssNode MR_createEntity];
                        [node initFromTempNode:nodeModel];
                        [node setCreatedAt:[NSDate date]];
                        [node setRss:aNewRss];
                    }
                }
                
                /**
                 *  reload the rss list
                 */
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
                [wself reloadRssList];
                
            } failure:^(NSError *error) {
                
            }];
        }
            break;
    }
}
@end
