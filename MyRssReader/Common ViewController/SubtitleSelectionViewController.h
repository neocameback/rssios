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

-(void) subtitleSelectionViewController:(SubtitleSelectionViewController*) viewcontroller didSelectSubWithUrl:(NSString *) url;

@end

@interface SubtitleSelectionViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;
/**
 *  play video from node list
 */
@property (nonatomic, strong) RssNodeModel *currentNode;

/**
 *  play video from downloaded list
 */
@property (nonatomic, strong) File *downloadedFile;

@property (nonatomic, weak) id<SubtitleSelectionViewControllerDelegate> delegate;
@end