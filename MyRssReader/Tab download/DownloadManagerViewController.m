//
//  DownloadManagerViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 8/13/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import "DownloadManagerViewController.h"
#import "File.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DownloadManager.h"
#import "MyPlayerViewController.h"

@interface DownloadManagerViewController ()<NSFetchedResultsControllerDelegate>
{
    NSMutableArray *files;
    NSTimer *_timer;
}
@property (nonatomic, strong) MPMoviePlayerViewController *player;
@end

@implementation DownloadManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Download";
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    
    [self.searchDisplayController.searchResultsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getFileList];
    
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(getFileList) userInfo:nil repeats:YES];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

-(void) getFileList
{
    
    files = [NSMutableArray arrayWithArray:[File MR_findAllSortedBy:@"createdAt" ascending:NO inContext:[NSManagedObjectContext MR_defaultContext]]];
    if (!_tableView.isEditing) {
        [_tableView reloadData];
    }
    
    NSArray *downloadingFiles = [File MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"progress < 100"]];
    if (downloadingFiles.count <= 0) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark search bar implement
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchResults = [files filteredArrayUsingPredicate:resultPredicate];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark UITableViewDatasource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return files.count;
    }
}
-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"DownloadManageTableViewCell";
    DownloadManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DownloadManageTableViewCell" owner:self options:nil] firstObject];
    }
    
    File *file = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        file = [searchResults objectAtIndex:indexPath.row];
    } else {
        file = [files objectAtIndex:indexPath.row];
    }
    
    cell.file = file;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    File *recipe = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        recipe = [searchResults objectAtIndex:indexPath.row];
    } else {
        recipe = [files objectAtIndex:indexPath.row];
    }
    
    switch (recipe.stateValue) {
        case DownloadStateCompleted:
        {
            NSString *path = [recipe getFilePath];
            
            NSLog(@"open video at path: %@",path);
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                NSLog(@"file is exist");
            }
            if ([[NSFileManager defaultManager] isReadableFileAtPath:path]) {
                MyPlayerViewController *playerVC = [[MyPlayerViewController alloc] initWithNibName:NSStringFromClass([MyPlayerViewController class]) bundle:nil];
                [playerVC setDownloadedFile:recipe];
                [self presentViewController:playerVC animated:YES completion:nil];
            }
        }
            break;
        default:
        {
        }
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        File *file = [files objectAtIndex:indexPath.row];
        [[DownloadManager shareManager] deleteFile:file];
        
        [files removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.player = nil;
}
@end
