//
//  DownloadManagerViewController.h
//  MyRssReader
//
//  Created by Huyns89 on 8/13/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import "BaseViewController.h"
#import "File.h"
#import "DownloadManageTableViewCell.h"

@interface DownloadManagerViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *_tableView;
}
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)configureCell:(DownloadManageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
