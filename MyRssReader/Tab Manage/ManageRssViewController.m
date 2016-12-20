//
//  AddNewRssViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/23/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "ManageRssViewController.h"
#import "RssModel.h"
#import "RssNode.h"

@interface ManageRssViewController ()
{
    RssManager *manager;
}
@end

@implementation ManageRssViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Channels";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onShowSideMenu:)];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(onEdit)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd)];
    
    self.navigationItem.rightBarButtonItems = @[addButton, editButton];
    
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    editingIndex = -1;
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

-(void) onEdit
{
    if (_tableView.editing) {
        _tableView.editing = NO;
    }else{
        _tableView.editing = YES;
    }
}
-(void) onAdd
{
    _tableView.editing = NO;
    
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
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"Manage Channels View";
    
    [self reloadRssList];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Save ManagedObjectContext using MagicalRecord
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)reloadRssList {
    self.rssList = [[NSMutableArray alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isBookmarkRss == 1"];
    self.rssList = [[NSMutableArray alloc] initWithArray:[Rss MR_findAllSortedBy:@"rssTitle" ascending:YES withPredicate:predicate]];
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark uitableview datasource and delegate
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
    Rss *aRss = self.rssList[indexPath.row];
    cell.textLabel.text = [aRss rssTitle];
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Rss *rss = self.rssList[indexPath.row];
    
    editingIndex = indexPath.row;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit Channel" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [[alert textFieldAtIndex:0] setPlaceholder:@"Put rss name here."];
    [[alert textFieldAtIndex:0] setClearButtonMode:UITextFieldViewModeWhileEditing];
    [[alert textFieldAtIndex:0] setText:rss.rssTitle];
    [[alert textFieldAtIndex:1] setPlaceholder:@"Put rss link here."];
    [[alert textFieldAtIndex:1] setText:rss.rssLink];
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
            if (editingIndex >= 0) {
                Rss *rss = self.rssList[editingIndex];
                [rss MR_deleteEntity];
                [self.rssList removeObjectAtIndex:editingIndex];
                editingIndex = -1;
            }
            
            self.aNewRssName = [[alertView textFieldAtIndex:0] text];
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
                wself.aNewRss = [Rss MR_findFirstByAttribute:@"rssLink" withValue:rssModel.rssLink];
                if (!wself.aNewRss) {
                    wself.aNewRss = [Rss MR_createEntity];
                }
                [[wself.aNewRss nodeListSet] removeAllObjects];
                if (rssModel.shouldCache) {
                    wself.aNewRss.shouldCacheValue = YES;
                }else{
                    wself.aNewRss.shouldCacheValue = NO;
                }
                [wself.aNewRss setIsBookmarkRssValue:YES];
                [wself.aNewRss setCreatedAt:[NSDate date]];
                [wself.aNewRss setUpdatedAt:[NSDate date]];
                if (wself.aNewRssName && wself.aNewRssName.length > 0) {
                    wself.aNewRss.rssTitle = wself.aNewRssName;
                }else{
                    wself.aNewRss.rssTitle = rssModel.rssTitle;
                }
                wself.aNewRss.originalTitle = rssModel.rssTitle;

                wself.aNewRss.rssLink = rssModel.rssLink;
                
                /**
                 *  if this rss should be cache so create new RssNode entity
                 */
                if (wself.aNewRss && wself.aNewRss.shouldCacheValue) {
                    for (RssNodeModel *nodeModel in nodeList) {
                        RssNode *node = [RssNode MR_createEntity];
                        [node initFromTempNode:nodeModel];
                        [node setCreatedAt:[NSDate date]];
                        [node setRss:wself.aNewRss];
                        [wself.aNewRss.nodeListSet addObject:node];
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
