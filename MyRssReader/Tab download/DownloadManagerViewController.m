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
//    [self reloadFetchedResults:nil];
//    
//    // observe the app delegate telling us when it's finished asynchronously setting up the persistent store
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFetchedResults:) name:@"RefetchAllDatabaseData" object:[[UIApplication sharedApplication] delegate]];
    
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
- (void)reloadFetchedResults:(NSNotification*)note {
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDatasource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView

{
//    NSInteger count = self.fetchedResultsController.sections.count;
//    if (count == 0) {
//        count = 1;
//    }
//    return count;
    
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSInteger numberOfRows = 0;
//    if (self.fetchedResultsController.sections.count > 0) {
//        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
//        numberOfRows = [sectionInfo numberOfObjects];
//    }
//    return numberOfRows;
    
    return files.count;
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
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(DownloadManageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
//    File *file = (File *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    File *file = [files objectAtIndex:indexPath.row];
    cell.file = file;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    File *recipe = (File *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    File *recipe = [files objectAtIndex:indexPath.row];
    switch (recipe.stateValue) {
        case DownloadStateCompleted:
        {
            NSString *path = [Common getPathOfFile:recipe.name extension:recipe.type];
            
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

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    // Set up the fetched results controller if needed.
    if (_fetchedResultsController == nil) {
        self.fetchedResultsController = [File MR_fetchAllSortedBy:@"createdAt" ascending:NO withPredicate:nil groupBy:nil delegate:self];
    }
    
    return _fetchedResultsController;
}

/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [_tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = _tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(DownloadManageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [_tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [_tableView endUpdates];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.player = nil;
}
@end
