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
{
    NSMutableArray *_data;
}
@end

@implementation SubtitleSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _tableView.estimatedRowHeight = 44;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    _data = [NSMutableArray array];
    SubtitleModel *cancelModel = [[SubtitleModel alloc] init];
    [cancelModel setName:@"None"];
    [cancelModel setLanguageName:@"None"];
    cancelModel.isSelected = _currentSubtitleURL ? NO : YES;
    
    [_data addObject:cancelModel];
    if (_downloadedFile) {
        for (Subtitle *sub in _downloadedFile.subtitlesSet) {
            SubtitleModel *model = [[SubtitleModel alloc] initWithSubtitle:sub];
            if (_currentSubtitleURL && [_currentSubtitleURL isEqualToString:model.filePath]) {
                model.isSelected = YES;
            }else{
                model.isSelected = NO;
            }
            [_data addObject:model];
        }
    }else{
        for (MWFeedItemSubTitle *subtitle in _currentNode.subtitles) {
            SubtitleModel *model = [[SubtitleModel alloc] initWithMWFeedItemSubtitle:subtitle];
            if (_currentSubtitleURL && [_currentSubtitleURL isEqualToString:model.link]) {
                model.isSelected = YES;
            }else{
                model.isSelected = NO;
            }
            [_data addObject:model];
        }
    }
    [_tableView reloadData];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
    self.navigationItem.title = @"Subtitles";
}

-(void) onCancel:(id) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    SubtitleModel *model = _data[indexPath.row];
    cell.textLabel.text = model.name;
    if (model.isSelected) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
    SubtitleModel *model = _data[indexPath.row];
    if (_downloadedFile) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(subtitleSelectionViewController:didSelectSubWithFileURL:)]) {
            [self.delegate subtitleSelectionViewController:self didSelectSubWithFileURL:model.filePath];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(subtitleSelectionViewController:didSelectSubWithStringURL:)]) {
            [self.delegate subtitleSelectionViewController:self didSelectSubWithStringURL:model.link];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

@end
