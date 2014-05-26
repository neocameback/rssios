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

@interface NodeListViewController ()
{
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

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currentRss.nodes.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Node *node = [[_currentRss nodes] allObjects][indexPath.row];
    NSLog(@"node image: %@",node.nodeImage);
    NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.imageView setImageWithURL:[NSURL URLWithString:[node nodeImage]] placeholderImage:nil];
    cell.textLabel.text = [node nodeTitle];
    cell.detailTextLabel.text = [node nodeUrl];
    return cell;
}
@end
