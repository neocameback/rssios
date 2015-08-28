//
//  FileListViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 8/28/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import "FileListViewController.h"
#import "TempNode.h"
#import "NodeListCustomCell.h"
#import "RPNodeDescriptionViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NodeListViewController.h"
#import <DMPlayerViewController.h>
#import "WebViewViewController.h"
#import <XCDYouTubeKit.h>
#import <AFNetworking.h>
#import <AFgzipRequestSerializer.h>

@interface FileListViewController ()
{
    MPMoviePlayerViewController *moviePlayer;
    NodeListCustomCell *nodeCell;
    NSString *identifier;
    TempNode *currentNode;
}
@end

@implementation FileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    identifier = @"NodeListCustomCell";
    UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
    nodeCell = [nib instantiateWithOwner:self options:nil][0];
    [_tableView registerNib:nib forCellReuseIdentifier:identifier];
    [self.searchDisplayController.searchResultsTableView registerNib:nib forCellReuseIdentifier:identifier];
    
    interstitial_ = [self createAndLoadInterstital];
    [self getWebContent];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void) getWebContent
{
    NSLog(@"webPageUrl: %@",self.webPageUrl);
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webPageUrl]]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *content = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"content: %@",content);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFgzipRequestSerializer serializerWithSerializer:[AFJSONRequestSerializer serializer]];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        NSDictionary *parameters = @{@"url": self.webPageUrl, @"file": content};
        [manager POST:POST_HANDLE_URL
           parameters:parameters
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSLog(@"%@", responseObject);
                  if (!nodeList) {
                      nodeList = [NSMutableArray array];
                  }
                  for (NSDictionary *item in responseObject[@"files"]) {
                      TempNode *tempNode = [[TempNode alloc] initWithFile:item];
                      [nodeList addObject:tempNode];
                  }
                  [_tableView reloadData];
                  [SVProgressHUD dismiss];
              }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                  [alert show];
                  [self.navigationController popViewControllerAnimated:YES];
                  NSLog(@"[Error] %@", error);
                  [SVProgressHUD dismiss];
              }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD dismiss];
    }];
    [operation start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        TempNode *node = nodeList[indexPath.row];
        [nodeCell configWithNode:node];
        [nodeCell layoutIfNeeded];
        CGFloat height = [nodeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        if (height < 71) {
            return 71;
        }else{
            return height + 1;
        }
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return nodeList.count;
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TempNode *node = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        node = searchResults[indexPath.row];
    } else {
        node = nodeList[indexPath.row];
    }
    
    NodeListCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell configWithNode:node];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    currentNode = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        currentNode = searchResults[indexPath.row];
    } else {
        currentNode = nodeList[indexPath.row];
    }    
    switch ([Common typeOfNode:currentNode.nodeType]) {
        case NODE_TYPE_RSS:
        {
            /**
             *  parse rss/xml
             */
            [self continueAtCurrentPath];
        }
            break;
        case NODE_TYPE_VIDEO:
        {
            [self preLoadInterstitial];
        }
            break;
        case NODE_TYPE_MP4:
        {
            [self preLoadInterstitial];
        }
            break;
        case NODE_TYPE_YOUTUBE:
        {
            [self preLoadInterstitial];
        }
            break;
        case NODE_TYPE_DAILYMOTION:
        {
            [self preLoadInterstitial];
        }
            break;
        case NODE_TYPE_RTMP:
        {
            [self preLoadInterstitial];
        }
            break;
            
        default:
        {
            [self preLoadInterstitial];
        }
            break;
    }
}
-(void) continueAtCurrentPath
{
    /**
     *  check if node url is empty or not
     */
    if (!currentNode.nodeUrl || currentNode.nodeUrl.length <= 0) {
        
        RPNodeDescriptionViewController *viewcontroller = [Storyboard instantiateViewControllerWithIdentifier:@"RPNodeDescriptionViewController"];
        [viewcontroller setTitle:currentNode.nodeTitle];
        [viewcontroller setDesc:currentNode.nodeDesc];
        [viewcontroller setUrl:currentNode.nodeLink];
        [self.navigationController pushViewController:viewcontroller animated:YES];
        return;
    }
    /**
     *  otherwise
     */
    switch ([Common typeOfNode:currentNode.nodeType]) {
        case NODE_TYPE_RSS:
        {
            NodeListViewController *viewcontroller = [NodeListViewController initWithNibName];
            [viewcontroller setRssURL:currentNode.nodeUrl];
            [viewcontroller setTitle:currentNode.nodeTitle];
            [self.navigationController pushViewController:viewcontroller animated:YES];
        }
            break;
        case NODE_TYPE_VIDEO:
        {
            moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:currentNode.nodeUrl]];
            [self presentMoviePlayerViewControllerAnimated:moviePlayer];
        }
            break;
        case NODE_TYPE_MP4:
        {
            moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:currentNode.nodeUrl]];
            [self presentMoviePlayerViewControllerAnimated:moviePlayer];
        }
            break;
        case NODE_TYPE_YOUTUBE:
        {
            XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:[currentNode.nodeUrl extractYoutubeId]];
            [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
        }
            break;
        case NODE_TYPE_DAILYMOTION:
        {
            NSString *url = currentNode.nodeUrl;
            NSString *videoIdentifer = [url lastPathComponent];
            
            DMPlayerViewController *playerViewcontroller = [[DMPlayerViewController alloc] initWithVideo:videoIdentifer];
            [playerViewcontroller setTitle:currentNode.nodeTitle];
            [playerViewcontroller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:playerViewcontroller animated:YES];
        }
            break;
        case NODE_TYPE_WEB_CONTENT:
        {
            FileListViewController *viewcontroller = [Storyboard instantiateViewControllerWithIdentifier:@"FileListViewController"];
            [viewcontroller setTitle:currentNode.nodeTitle];
            [viewcontroller setWebPageUrl:currentNode.nodeUrl];
            [self.navigationController pushViewController:viewcontroller animated:YES];
        }
            break;
        default:
        {
            WebViewViewController *viewcontroller = [WebViewViewController initWithNibName];
            [viewcontroller setTitle:currentNode.nodeTitle];
            [viewcontroller setWebUrl:currentNode.nodeUrl];
            [self.navigationController pushViewController:viewcontroller animated:YES];
        }
            break;
    }
}

#pragma mark Admob
#pragma mark Interstitial delegate
-(GADInterstitial*) createAndLoadInterstital
{
    GADRequest *request = [GADRequest request];
    GADInterstitial * interstitial = nil;
        interstitial = [[GADInterstitial alloc] initWithAdUnitID:kLargeAdUnitId];
    interstitial.delegate = self;
    [interstitial loadRequest:request];
    
    return interstitial;
}

- (void)preLoadInterstitial {
    //Call this method as soon as you can - loadRequest will run in the background and your interstitial will be ready when you need to show it
    
    NSDate *lastOpenDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastOpenFullScreen];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastOpenDate];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastOpenFullScreen];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (interval <= kSecondsToPresentInterstitial) {
        [self continueAtCurrentPath];
        return;
    }
    if (interstitial_.isReady) {
        [interstitial_ presentFromRootViewController:self];
    }else{
        [self continueAtCurrentPath];
    }
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    NSLog(@"interstitialDidReceiveAd");
}
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"didFailToReceiveAdWithError: %@",[error localizedDescription]);
    //If an error occurs and the interstitial is not received you might want to retry automatically after a certain interval
    [self createAndLoadInterstital];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    [self createAndLoadInterstital];
    [self continueAtCurrentPath];
}

#pragma mark search bar implement
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"nodeTitle contains[c] %@", searchText];
    searchResults = [nodeList filteredArrayUsingPredicate:resultPredicate];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

@end
