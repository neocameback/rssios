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
    NSMutableArray *rssList;
    RssManager *manager;
}
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
}
-(void) showBanner
{
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.screenName = @"Home View";
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isBookmarkRss == 1"];
        rssList = [[NSMutableArray alloc] initWithArray:[Rss MR_findAllSortedBy:@"rssTitle" ascending:YES withPredicate:predicate]];

        [_tableView reloadData];
    }
    else // first time lauche application, we'll save a sample RSS url
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        manager = [[RssManager alloc] initWithRssUrl:[NSURL URLWithString:kDefaultRssUrl]];
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
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                rssList = [[NSMutableArray alloc] initWithArray:[Rss MR_findAllSortedBy:@"rssTitle" ascending:YES]];
                [_tableView reloadData];
            }];
            
        } failure:^(NSError *error) {
            
        }];
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
    cell.textLabel.text = [rssList[indexPath.row] rssTitle];
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NodeListViewController *viewcontroller = [NodeListViewController initWithNibName];
    [viewcontroller setTitle:[rssList[indexPath.row] rssTitle]];
    [viewcontroller setRssURL:[rssList[indexPath.row] rssLink]];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}
@end
