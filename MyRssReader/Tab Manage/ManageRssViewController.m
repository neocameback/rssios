//
//  AddNewRssViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/23/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "ManageRssViewController.h"
#import "TempRss.h"
#import "RssNode.h"

@interface ManageRssViewController ()

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
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(onEdit)];
    self.navigationItem.leftBarButtonItem = editButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd)];
    self.navigationItem.rightBarButtonItem = addButton;
    
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
            [SVProgressHUD showWithStatus:kStringLoading maskType:SVProgressHUDMaskTypeGradient];
            [Common getUserIpAddress:^(NSDictionary *update) {
                if (update) {
                    NSString *ipAddress = update[@"ip"];
                    NSMutableURLRequest *request = [Common requestWithMethod:@"GET" ipAddress:ipAddress Url:urlString];
                    if (!request) {
                        return;
                    }
                    feedParser = [[MWFeedParser alloc] initWithFeedRequest:request];
                    
                    feedParser.delegate = self;
                    // Parse the feeds info (title, link) and all feed items
                    feedParser.feedParseType = ParseTypeFull;
                    // Connection type
                    feedParser.connectionType = ConnectionTypeAsynchronously;
                    // Begin parsing
                    if ([self isInternetConnected]) {
                        [feedParser parse];
                    }else{
                        [SVProgressHUD popActivity];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:kMessageInternetConnectionLost delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                }
            } failureBlock:^(NSError * error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [SVProgressHUD popActivity];
            }];
        }
            break;
    }
}
#pragma mark MWFeedParser delegate
- (void)feedParserDidStart:(MWFeedParser *)parser
{
    
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info
{
    newRss = [Rss MR_findFirstByAttribute:@"rssLink" withValue:info.url];
    if (!newRss) {
        newRss = [Rss MR_createEntity];
    }else{
        [[newRss nodeListSet] removeAllObjects];
    }
    if ([info shouldCache] != nil && ([[info shouldCache] caseInsensitiveCompare:@"false"] == NSOrderedSame)) {
        newRss.shouldCacheValue = NO;
    }else{
        newRss.shouldCacheValue = YES;
    }
    [newRss setIsBookmarkRssValue:YES];
    [newRss setCreatedAt:[NSDate date]];
    [newRss setUpdatedAt:[NSDate date]];
    if (newRssName && newRssName.length > 0) {
        newRss.rssTitle = newRssName;
    }else{
        newRss.rssTitle = info.title;
    }
    NSString *strippedString = [info.url absoluteString];
    NSUInteger queryLength = [[info.url query] length];
    strippedString = (queryLength ? [strippedString substringToIndex:[strippedString length] - (queryLength + 1)] : strippedString);
    newRss.rssLink = strippedString;
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
    TempNode *tempNode = [[TempNode alloc] initWithFeedItem:item];
    if (newRss && newRss.shouldCacheValue) {
        RssNode *node = [RssNode MR_createEntity];
        [node setCreatedAt:[NSDate date]];
        [node initFromTempNode:tempNode];
        [node setRss:newRss];
    }
}
- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [SVProgressHUD popActivity];
    
    if (!rssList) {
        rssList = [[NSMutableArray alloc] init];
    }
    [rssList addObject:newRss];
    [_tableView reloadData];
}
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error
{
    [SVProgressHUD popActivity];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                    message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
