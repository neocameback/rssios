//
//  AddNewRssViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/23/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "ManageRssViewController.h"

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
    if (!rssList) {
        rssList = [[NSMutableArray alloc] init];
    }else{
        [rssList removeAllObjects];
    }
    rssList = [[NSMutableArray alloc] initWithArray:[Rss MR_findAllSortedBy:@"rssTitle" ascending:YES]];
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
    
    [rssList removeObjectAtIndex:indexPath.row];
    
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
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
            
            break;
        default:
        {
            newRssName = [[alertView textFieldAtIndex:0] text];
            NSString *urlString = [[alertView textFieldAtIndex:1] text];
            
            BOOL result = [[urlString lowercaseString] hasPrefix:@"http://"];
            NSURL *urlAddress = nil;
            
            if (result) {
                urlAddress = [NSURL URLWithString: urlString];
            }
            else {
                NSString *good = [NSString stringWithFormat:@"http://%@", urlString];
                urlAddress = [NSURL URLWithString: good];
            }
            
            feedParser = [[MWFeedParser alloc] initWithFeedURL:urlAddress];
            feedParser.delegate = self;
            // Parse the feeds info (title, link) and all feed items
            feedParser.feedParseType = ParseTypeFull;
            // Connection type
            feedParser.connectionType = ConnectionTypeAsynchronously;
            // Begin parsing
            if ([self isInternetConnected]) {
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
                [feedParser parse];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Internet connection was lost!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
    }
}
- (void)feedParserDidStart:(MWFeedParser *)parser
{
    
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info
{
    newRss = [Rss MR_createEntity];
    if (newRssName && newRssName.length > 0) {
        newRss.rssTitle = newRssName;
    }else{
        newRss.rssTitle = info.title;
    }
    newRss.rssLink = info.link;
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
    Node *aNode = [Node MR_createEntity];
    aNode.nodeTitle = item.title;
    //    aNode.nodeSource = item.s
    if (item.enclosures.count > 0) {
        aNode.nodeType = item.enclosures[0][@"type"];
        aNode.nodeUrl = item.enclosures[0][@"url"];
    }
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    [regex enumerateMatchesInString:item.summary
                            options:0
                              range:NSMakeRange(0, [item.summary length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             
                             aNode.nodeImage = [item.summary substringWithRange:[result rangeAtIndex:2]];
                             aNode.nodeImage = [aNode.nodeImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                         }];
    
    aNode.currentRss = newRss;
    
}
- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    [SVProgressHUD dismiss];
    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    
    if (!rssList) {
        rssList = [[NSMutableArray alloc] init];
    }
    [rssList addObject:newRss];
    [_tableView reloadData];
}
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                    message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}
- (IBAction)onAdd:(id)sender {
}

- (IBAction)onCancel:(id)sender {
    [self.view endEditing:YES];
}
@end
