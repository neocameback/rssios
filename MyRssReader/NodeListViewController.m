//
//  NodeListViewController.m
//  MyRssReader
//
//  Created by Huyns89 on 5/26/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "NodeListViewController.h"
#import "Node.h"
#import <UIImageView+AFNetworking.h>
#import "NodeListCustomCell.h"
#import <XCDYouTubeVideoPlayerViewController.h>
#import "WebViewViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface NodeListViewController ()
{
    MPMoviePlayerViewController *moviePlayer;
}
@end

@implementation NodeListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currentRss.nodes.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Node *node = [[_currentRss nodes] allObjects][indexPath.row];
    
    NSString *identifier = @"NodeListCustomCell";
    NodeListCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NodeListCustomCell" owner:self options:nil][0];
    }
    [cell.iv_image setImageWithURL:[NSURL URLWithString:[node nodeImage]] placeholderImage:[UIImage imageNamed:@"default_rss_img"]];
    cell.lb_title.text = [node nodeTitle];
//    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Node *node = [[_currentRss nodes] allObjects][indexPath.row];
    
//    if ([node.nodeType caseInsensitiveCompare:@"web/html"] == NSOrderedSame && [node.nodeType rangeOfString:@"http://www.youtube.com"].location != NSNotFound ) {
//        NSString *videoIdentifier = nil;
//        NSArray *pairs = [node.nodeUrl componentsSeparatedByString:@"?"];
//        for (NSString *pair in pairs) {
//            NSArray *elements = [pair componentsSeparatedByString:@"&"];
//            for (NSString *element in elements) {
//                NSArray *components = [element componentsSeparatedByString:@"="];
//                {
//                    if ([components count] > 0) {
//                        if ([components[0] isEqualToString:@"v"]) {
//                            videoIdentifier = components[1];
//                        }
//                    }
//                }
//            }
//        }
//        XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoIdentifier];
//        [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
//    }
    if ([node.nodeType caseInsensitiveCompare:@"web/html"] == NSOrderedSame){
        WebViewViewController *viewcontroller = [WebViewViewController initWithNibName];
        [viewcontroller setWebUrl:node.nodeUrl];
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
    else if ([node.nodeType caseInsensitiveCompare:@"application/x-mpegurl"] == NSOrderedSame || [node.nodeType caseInsensitiveCompare:@"video/mp4"] == NSOrderedSame){
//        if (!moviewPlayer) {
            moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:node.nodeUrl]];
//        }
        [self presentViewController:moviePlayer animated:YES completion:nil];
    }
}
@end
