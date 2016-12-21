//
//  RSSLeftMenuViewController.m
//  MyRssReader
//
//  Created by Huy Nguyen on 10/21/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "RSSLeftMenuViewController.h"
#import "RssListViewController.h"
#import "ManageRssViewController.h"
#import "BookmarkViewController.h"
#import "AboutViewController.h"
#import "DownloadManagerViewController.h"
#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "RssBaseNavigationViewController.h"

@interface RSSLeftMenuViewController ()

@property (nonatomic) NSInteger selectedCellIndex;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UINavigationController *homeNav;
@property (nonatomic, strong) UINavigationController *favoriteNav;
@property (nonatomic, strong) UINavigationController *downloadNav;
@property (nonatomic, strong) UINavigationController *settingsNav;
@end

@implementation RSSLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.images = [NSMutableArray arrayWithArray:@[@"video-camera", @"star", @"download", @"settings"]];
    self.data = [NSMutableArray arrayWithArray:@[@"Channel", @"Favorite", @"Download", @"Setting"]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UINavigationController *)centerViewController {
    return self.homeNav;
}

- (UINavigationController *)homeNav {
    if (_homeNav) {
        return _homeNav;
    } else {
        RssListViewController *rssVC = [RssListViewController initWithNibName];
        _homeNav = [[RssBaseNavigationViewController alloc] initWithRootViewController:rssVC];
        return _homeNav;
    }
}

- (UINavigationController *)favoriteNav {
    if (_favoriteNav) {
        return _favoriteNav;
    } else {
        BookmarkViewController *viewcontroller = [BookmarkViewController initWithNibName];
        _favoriteNav = [[RssBaseNavigationViewController alloc] initWithRootViewController:viewcontroller];
        return _favoriteNav;
    }
}

- (UINavigationController *)downloadNav {
    if (_downloadNav) {
        return _downloadNav;
    } else {
        DownloadManagerViewController *viewcontroller = [DownloadManagerViewController initWithNibName];
        _downloadNav = [[RssBaseNavigationViewController alloc] initWithRootViewController:viewcontroller];
        return _downloadNav;
    }
}

- (UINavigationController *)settingsNav {
    if (_settingsNav) {
        return _settingsNav;
    } else {
        AboutViewController *viewcontroller = [AboutViewController initWithNibName];
        _settingsNav = [[RssBaseNavigationViewController alloc] initWithRootViewController:viewcontroller];
        return _settingsNav;
    }
}

#pragma mar UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"sideMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case RSSSideMenuHome: {
            if (indexPath.row == self.selectedCellIndex) {
                [self.homeNav popToRootViewControllerAnimated:YES];
            } else {
                self.mm_drawerController.centerViewController = self.homeNav;
            }

        }
            break;        
        case RSSSideMenuFavorite: {
            if (indexPath.row == self.selectedCellIndex) {
                [self.favoriteNav popToRootViewControllerAnimated:YES];
            } else {
                self.mm_drawerController.centerViewController = self.favoriteNav;
            }
        }
            break;
        case RSSSideMenuDownload: {
            if (indexPath.row == self.selectedCellIndex) {
                [self.downloadNav popToRootViewControllerAnimated:YES];
            } else {
                self.mm_drawerController.centerViewController = self.downloadNav;
            }
        }
            break;
        case RSSSideMenuAbout: {
            if (indexPath.row == self.selectedCellIndex) {
                [self.settingsNav popToRootViewControllerAnimated:YES];
            } else {
                self.mm_drawerController.centerViewController = self.settingsNav;
            }
        }
            break;
    }
    self.selectedCellIndex = indexPath.row;
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}
@end
