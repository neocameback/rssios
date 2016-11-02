//
//  AboutViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/27/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "AboutViewController.h"
#import "WebViewViewController.h"
#import "SubtitleSettingsViewController.h"
#import "Rss.h"

#define minuteToSecond 60

@interface AboutViewController () <UIActionSheetDelegate>
{
    NSArray *times;
}
@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Settings";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    times = @[@5, @10, @15, @20, @25, @30];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onShowSideMenu:)];
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"About View";
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 2;
        default:
            return 1;
    }
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0: {
                    cell.textLabel.text = @"Auto refresh RSS time:";
                    NSInteger autoRefreshTime = [[NSUserDefaults standardUserDefaults] integerForKey:kAutoRefreshNewsTime];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld minutes",autoRefreshTime/minuteToSecond];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
                }
                    break;
                case  1: {
                    cell.textLabel.text = @"Clear cache";
                    cell.detailTextLabel.text = @"";
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
                }
                    break;
                default: { // open subtitle setting view
                    cell.textLabel.text = @"Subtitle appearance";
                    cell.detailTextLabel.text = @"";
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
                }
                    break;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"About us";
                cell.detailTextLabel.text = @"";
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
            }else{
                cell.textLabel.text = @"Tell your friends";
                cell.detailTextLabel.text = @"";
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
            }
        }
            break;
        default:
        {
            cell.textLabel.text = @"Version";
            NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
            NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
            NSString *buildVersion = [info objectForKey:@"CFBundleVersion"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)",version,buildVersion];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
    }
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0: {
                    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"Auto refresh RSS after" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
                    [actionsheet setTag:1];
                    for (NSNumber *number in times) {
                        [actionsheet addButtonWithTitle:[NSString stringWithFormat:@"%ld minutes",(long)[number integerValue]]];
                    }
                    [actionsheet showInView:self.view];
                }
                    break;
                case 1: {
                    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to clear cache?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear" otherButtonTitles: nil];
                    [actionsheet setTag:2];
                    [actionsheet showInView:self.view];
                }
                    break;
                default: {
                    SubtitleSettingsViewController *viewcontroller = [SubtitleSettingsViewController initWithNibName];
                    [self.navigationController pushViewController:viewcontroller animated:YES];
                }
                    break;
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                [self onAboutus:nil];
            }else{
                [self onShare:nil];
            }
            break;
        default:
            break;
    }
}
- (void)onAboutus:(id)sender {
    WebViewViewController *vc = [WebViewViewController initWithNibName];
    [vc setTitle:@"About us"];
    [vc setWebUrl:kAboutUrl];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)onShare:(id)sender {
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[kDefaultShareTitle] applicationActivities:nil];
    
    NSArray *excludedActivities = nil;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        excludedActivities = @[UIActivityTypePostToTwitter,
                               UIActivityTypePostToWeibo,
                               UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                               UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                               UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                               UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
    }else{
        excludedActivities = @[UIActivityTypePostToTwitter,
                               UIActivityTypePostToWeibo,
                               UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                               UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    }
    controller.excludedActivityTypes = excludedActivities;
    if ([UIPopoverPresentationController class] != nil) {
        UIPopoverPresentationController *popover = controller.popoverPresentationController;
        if (popover)
        {
            popover.sourceView = self.view;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
    }
    [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    switch (actionSheet.tag) {
        case 1:
        {
            if (buttonIndex != [actionSheet cancelButtonIndex]) {
                NSNumber *selectedNumber = times[buttonIndex - 1];
                [[NSUserDefaults standardUserDefaults] setInteger:[selectedNumber integerValue]*minuteToSecond forKey:kAutoRefreshNewsTime];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [_tableView reloadData];
            }
        }
            break;
            
        default:
        {
            if (buttonIndex != [actionSheet cancelButtonIndex]) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isBookmarkRss == 0"];
                NSArray *cachedRss = [Rss MR_findAllSortedBy:@"rssTitle" ascending:YES withPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
                for (Rss *rss in cachedRss) {
                    [rss MR_deleteEntity];
                }
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }
        }
            break;
    }
}

@end
