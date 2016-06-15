//
//  FileListViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 8/28/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import "FileListViewController.h"
#import "RssNodeModel.h"
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
    RssNodeModel *currentNode;
}
@end

@implementation FileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getWebContent];        
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void) getWebContent
{
    [SVProgressHUD showWithStatus:kStringLoading maskType:SVProgressHUDMaskTypeGradient];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.webPageUrl]];
    [request setValue:kUserAgent forHTTPHeaderField:@"User-Agent"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *content = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFgzipRequestSerializer serializerWithSerializer:[AFJSONRequestSerializer serializer]];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        NSDictionary *parameters = @{@"url": self.webPageUrl, @"file": content};
        
        [manager POST:POST_HANDLE_URL
           parameters:parameters
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  if (!self.nodeList) {
                      self.nodeList = [NSMutableArray array];
                  }
                  for (NSDictionary *item in responseObject[@"files"]) {
                      RssNodeModel *tempNode = [[RssNodeModel alloc] initWithFile:item];
                      [self.nodeList addObject:tempNode];
                  }
                  [self.tableView reloadData];
                  [SVProgressHUD dismiss];
              }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                  [alert show];
                  [self.navigationController popViewControllerAnimated:YES];
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

-(NSString *) cellIdentifier
{
    return NSStringFromClass([NodeListCustomCell class]);
}

-(ConfigureTableViewCellBlock) configureCellBlock
{
    ConfigureTableViewCellBlock configureCellBlock = ^(NodeListCustomCell *cell, RssNodeModel *nodeModel){
        [cell configWithNode:nodeModel];
    };
    return configureCellBlock;
}

@end
