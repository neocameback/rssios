//
//  BookmarkCustomCell.h
//  MyRssReader
//
//  Created by Huyns89 on 5/27/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"

@interface BookmarkCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
-(void) configWithNode:(Node*) node;

@end
