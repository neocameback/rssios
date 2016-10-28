//
//  SubtitleSelectionViewController.h
//  MyRssReader
//
//  Created by Huy on 6/26/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "BaseViewController.h"
#import "File.h"

@class SubtitleSelectionViewController;
@protocol SubtitleSelectionViewControllerDelegate <NSObject>

-(void) subtitleSelectionViewController:(SubtitleSelectionViewController*) viewcontroller
               didSelectSubtitleAtIndex:(NSInteger)index;

@end

@interface SubtitleSelectionViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *subtitleModels;
@property (nonatomic) NSInteger selectedSubtitleIndex;
@property (nonatomic, weak) id<SubtitleSelectionViewControllerDelegate> delegate;
@end
