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
#import "LocalPlayerViewController.h"

@interface DownloadManagerViewController ()<NSFetchedResultsControllerDelegate, MGSwipeTableCellDelegate>
{
    NSMutableArray *files;
    NSTimer *_timer;
    
    UITextField *_tfName;
    
    File *selectedFile;
}
@property (nonatomic, strong) MPMoviePlayerViewController *player;
@end

@implementation DownloadManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Download";
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _interstitial = [self createAndLoadInterstital];
    
    [self.searchDisplayController.searchResultsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
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
    
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(getFileList) userInfo:nil repeats:YES];
    
    [self getFileList];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
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
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 8, 0, 0)];
    }
    
    File *file = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        file = [searchResults objectAtIndex:indexPath.row];
    } else {
        file = [files objectAtIndex:indexPath.row];
    }
    cell.file = file;
    
    if (file.stateValue == DownloadStateCompleted) {
        cell.delegate = self;
        __weak typeof(self) wself = self;
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
            [wself onDeleteDownloadededFileAtIndex:indexPath];
            return YES;
        }],
                              [MGSwipeButton buttonWithTitle:@"Rename" backgroundColor:[UIColor lightGrayColor] callback:^BOOL(MGSwipeTableCell *sender) {
                                  [wself onEditDownloadededFileAtIndex:indexPath];
                                  return YES;
                              }]];
        cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
    }else{
        cell.delegate = nil;
        cell.rightButtons = @[];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    File *file = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        file = [searchResults objectAtIndex:indexPath.row];
    } else {
        file = [files objectAtIndex:indexPath.row];
    }
    
    switch (file.stateValue) {
        case DownloadStateCompleted:
        {
            selectedFile = file;
            [self preLoadInterstitial];
        }
            break;
        default:
        {
        }
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark continueAtCurrentPath after present interstital ads
-(void) continueAtCurrentPath
{
    NSString *path = [selectedFile getFilePath];
    if ([[NSFileManager defaultManager] isReadableFileAtPath:path]) {
        BOOL hasConnectedCastSession =
        [GCKCastContext sharedInstance].sessionManager.hasConnectedCastSession;
        if (hasConnectedCastSession) {
            [self castMediaInfo:[Common mediaInformationFromFile:selectedFile]];
        } else {
            LocalPlayerViewController *playerVC = [[LocalPlayerViewController alloc] initWithNibName:NSStringFromClass([LocalPlayerViewController class]) bundle:nil];
            [playerVC setDownloadedFile:selectedFile];
            [self presentViewController:playerVC animated:YES completion:nil];
        }
    }
}
#pragma mark Admob
#pragma mark Admob
#pragma mark Interstitial delegate
- (void)preLoadInterstitial
{
    //Call this method as soon as you can - loadRequest will run in the background and your interstitial will be ready when you need to show it
    
    NSDate *lastOpenDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastOpenFullScreen];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastOpenDate];
    
    if (interval <= kSecondsToPresentInterstitial) {
        [self continueAtCurrentPath];
        return;
    }
    if (_interstitial.isReady) {
        [_interstitial presentFromRootViewController:self];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastOpenFullScreen];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [self continueAtCurrentPath];
    }
}

-(GADInterstitial*) createAndLoadInterstital
{
    GADRequest *request = [GADRequest request];
    //    request.testDevices = @[ kGADSimulatorID ];
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:kLargeAdUnitId];
    interstitial.delegate = self;
    [interstitial loadRequest:request];
    
    return interstitial;
}

#pragma mark GADInterstitialDelegate
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
}
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    //If an error occurs and the interstitial is not received you might want to retry automatically after a certain interval
    _interstitial = [self createAndLoadInterstital];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    _interstitial = [self createAndLoadInterstital];
    [self continueAtCurrentPath];
}

-(void) onEditDownloadededFileAtIndex:(NSIndexPath *) indexPath
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Rename" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *newName = _tfName.text;
        newName = [newName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (!newName || newName.length == 0) {
            ALERT_WITH_TITLE(@"", @"Name cannot be empty.");
        }else{
            if ([DownloadManager isFileNameExist:_tfName.text]) {
                ALERT_WITH_TITLE(@"", @"You entered a file that already exist. Please choose an other file name.");
            }else{
                File *file = [files objectAtIndex:indexPath.row];
                [file rename:newName];
                                
                [_tableView reloadData];
            }
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [self addTextField:textField];
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) addTextField:(UITextField *) textField
{
    [textField setPlaceholder:@"Put new name here"];
    _tfName = textField;
}

-(void) onDeleteDownloadededFileAtIndex:(NSIndexPath *) indexPath
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure to delete this file?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        File *file = [files objectAtIndex:indexPath.row];
        [[DownloadManager shareManager] deleteFile:file];
        
        [files removeObjectAtIndex:indexPath.row];
        [_tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark MGSwipeTableCellDelegate
-(void) swipeTableCell:(MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState) state gestureIsActive:(BOOL) gestureIsActive
{
    if (state != MGSwipeStateNone) {
        
    }
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.player = nil;
}
@end
