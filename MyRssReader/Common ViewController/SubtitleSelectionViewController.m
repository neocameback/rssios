//
//  SubtitleSelectionViewController.m
//  MyRssReader
//
//  Created by Huy on 6/26/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "SubtitleSelectionViewController.h"
#import "SubtitleModel.h"

@interface SubtitleSelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SubtitleSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _tableView.estimatedRowHeight = 44;
    _tableView.rowHeight = UITableViewAutomaticDimension;
        
    SubtitleModel *cancelModel = [[SubtitleModel alloc] init];
    [cancelModel setName:@"None"];
    [cancelModel setLanguageName:@"None"];
    [self.subtitleModels insertObject:cancelModel atIndex:0];
    
    [_tableView reloadData];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
    self.navigationItem.title = @"Subtitles";
}

- (void)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setSubtitleModels:(NSMutableArray *)subtitleModels {
    _subtitleModels = [subtitleModels mutableCopy];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subtitleModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    SubtitleModel *model = self.subtitleModels[indexPath.row];
    cell.textLabel.text = model.name;
    if (indexPath.row - 1 == self.selectedSubtitleIndex) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];    
    if (self.delegate && [self.delegate respondsToSelector:@selector(subtitleSelectionViewController:didSelectSubtitleAtIndex:)]) {
        [self.delegate subtitleSelectionViewController:self didSelectSubtitleAtIndex:indexPath.row - 1];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
