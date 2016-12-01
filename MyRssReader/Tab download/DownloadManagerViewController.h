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
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface DownloadManagerViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, GADInterstitialDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    
    NSArray *searchResults;
}
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) GADInterstitial *interstitial;

@end
