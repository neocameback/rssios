//
//  BookmarkViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/23/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "BookmarkViewController.h"
#import "Node.h"
#import "BookmarkCustomCell.h"
#import "WebViewViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NodeListViewController.h"
#import <XCDYouTubeVideoPlayerViewController.h>
#import <DMPlayerViewController.h>
#import "FileListViewController.h"
#import "RPNodeDescriptionViewController.h"

@interface BookmarkViewController ()
{
    MPMoviePlayerViewController *moviePlayer;
    Node *currentNode;
}
@end

@implementation BookmarkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Favorites";        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onEdit)];
    self.navigationItem.leftBarButtonItem = editButton;
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.screenName = @"Favorites View";
    self.nodeList = [NSMutableArray array];
    
    NSArray *nodeArray = [[NSMutableArray alloc] initWithArray:[Node MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"isAddedToBoomark == 1"]]];
    for (Node *node in nodeArray) {
        RssNodeModel *model = [[RssNodeModel alloc] initWithBookmarkNode:node];
        [self.nodeList addObject:model];
    }
    [self.tableView reloadData];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Save ManagedObjectContext using MagicalRecord
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

-(void) onEdit
{
    if (self.tableView.editing) {
        self.tableView.editing = NO;
    }else{
        self.tableView.editing = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *) cellIdentifier
{
    return NSStringFromClass([BookmarkCustomCell class]);
}

-(ConfigureTableViewCellBlock) configureCellBlock
{
    ConfigureTableViewCellBlock configureCellBlock = ^(BookmarkCustomCell *cell, RssNodeModel *nodeModel){
        [cell configWithNode:nodeModel];
    };
    return configureCellBlock;
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
    RssNodeModel *model = self.nodeList[indexPath.row];
    
    [Node MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"nodeUrl == %@",model.nodeUrl] inContext:[NSManagedObjectContext MR_defaultContext]];
    [self.nodeList removeObjectAtIndex:indexPath.row];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    
    [self.tableView reloadData];
}

@end
