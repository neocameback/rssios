//
//  NodeListCustomCell.h
//  MyRssReader
//
//  Created by Huyns89 on 5/26/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RssNodeModel.h"

@class NodeListCustomCell;
@protocol NodeListCustomCellDelegate <NSObject>

-(void) NodeListCustomCell:(NodeListCustomCell*) cell didTapOnDownload:(id) sender;

@end


@interface NodeListCustomCell : UITableViewCell

@property (nonatomic, assign) RssNodeModel* node;
@property (weak, nonatomic) IBOutlet UIImageView *iv_image;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_addToFav;
@property (weak, nonatomic) UIViewController *parentVC;
@property (weak, nonatomic) id<NodeListCustomCellDelegate> delegate;
-(void) configWithNode:(RssNodeModel*) node;
@end
