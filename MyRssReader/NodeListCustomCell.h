//
//  NodeListCustomCell.h
//  MyRssReader
//
//  Created by Huyns89 on 5/26/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempNode.h"

@interface NodeListCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iv_image;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_addToFav;
-(void) configWithNode:(TempNode*) node;
@end
