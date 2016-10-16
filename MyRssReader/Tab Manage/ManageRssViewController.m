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
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onEdit)];
    self.navigationItem.leftBarButtonItem = editButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    editingIndex = -1;
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
    if (!rssList) {
        rssList = [[NSMutableArray alloc] init];
    }else{
        [rssList removeAllObjects];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isBookmarkRss == 1"];
    rssList = [[NSMutableArray alloc] initWithArray:[Rss MR_findAllSortedBy:@"rssTitle" ascending:YES withPredicate:predicate]];
    [_tableView reloadData];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Save ManagedObjectContext using MagicalRecord
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark uitableview datasource and delegate
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
    Rss *aRss = rssList[indexPath.row];
    cell.textLabel.text = [aRss rssTitle];
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Rss *rss = rssList[indexPath.row];
    
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
    Rss *aRss = rssList[indexPath.row];
    [aRss MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [rssList removeObjectAtIndex:indexPath.row];

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
                Rss *rss = rssList[editingIndex];
                [rss MR_deleteEntity];
                [rssList removeObjectAtIndex:editingIndex];
                editingIndex = -1;
            }
            
            newRssName = [[alertView textFieldAtIndex:0] text];
            NSString *urlString = [[alertView textFieldAtIndex:1] text];            
            BOOL result = [[urlString lowercaseString] hasPrefix:@"http://"];
            if (!result) {
                urlString = [NSString stringWithFormat:@"http://%@", urlString];
            }
            
            manager = [[RssManager alloc] initWithRssUrl:[NSURL URLWithString:urlString]];
            [manager startParseCompletion:^(RssModel *rssModel, NSMutableArray *nodeList) {
                /**
                 *  save the new RSS
                 */
                newRss = [Rss MR_findFirstByAttribute:@"rssLink" withValue:rssModel.rssLink];
                if (!newRss) {
                    newRss = [Rss MR_createEntity];
                }
                [[newRss nodeListSet] removeAllObjects];
                if (rssModel.shouldCache) {
                    newRss.shouldCacheValue = YES;
                }else{
                    newRss.shouldCacheValue = NO;
                }
                [newRss setIsBookmarkRssValue:YES];
                [newRss setCreatedAt:[NSDate date]];
                [newRss setUpdatedAt:[NSDate date]];
                if (newRssName && newRssName.length > 0) {
                    newRss.rssTitle = newRssName;
                }else{
                    newRss.rssTitle = rssModel.rssTitle;
                }

                newRss.rssLink = rssModel.rssLink;
                
                /**
                 *  if this rss should be cache so create new RssNode entity
                 */
                if (newRss && newRss.shouldCacheValue) {
                    for (RssNodeModel *nodeModel in nodeList) {
                        RssNode *node = [RssNode MR_createEntity];
                        [node initFromTempNode:nodeModel];
                        [node setCreatedAt:[NSDate date]];
                        [node setRss:newRss];
                    }
                }
                
                /**
                 *  reload the rss list
                 */
                [rssList addObject:newRss];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
                [_tableView reloadData];
                
            } failure:^(NSError *error) {
                
            }];
        }
            break;
    }
}

@end
