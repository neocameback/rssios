//
//  NodeListCustomCell.m
//  MyRssReader
//
//  Created by Huyns89 on 5/26/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "NodeListCustomCell.h"
#import <UIImageView+AFNetworking.h>
#import "Node.h"
#import <UIView+AnimationExtensions.h>

@implementation NodeListCustomCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) configWithNode:(RssNodeModel*) aNode
{
    _node = aNode;
    
    [self.iv_image setImageWithURL:[NSURL URLWithString:[_node nodeImage]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
    self.lb_title.text = [_node nodeTitle];
    /**
     *  Bookmark status default = yes
     *  if bookmarkStatus = false so hide the favorite button
     */
    if ([_node bookmarkStatus] != nil && ([[_node bookmarkStatus] caseInsensitiveCompare:@"false"] == NSOrderedSame)) {
        self.btn_addToFav.hidden = YES;
    }else{
        self.btn_addToFav.hidden = NO;
        NSString *nodeUrl = [_node nodeUrl];
        Node *node = [Node MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"nodeUrl == %@",nodeUrl] inContext:[NSManagedObjectContext MR_defaultContext]];
        if (!node) {
            self.btn_addToFav.selected = NO;
        }else{
            self.btn_addToFav.selected = YES;
        }
    }
    
    if ([Common typeOfNode:_node.nodeType] == NODE_TYPE_MP4) {
        UIButton *btnDownload = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *downloadIcon = [UIImage imageNamed:@"download-arrow"];
        [btnDownload setImage:downloadIcon forState:UIControlStateNormal];
        [btnDownload setFrame:CGRectMake(0, 0, downloadIcon.size.width, downloadIcon.size.height)];
        [btnDownload addTarget:self action:@selector(onDownload:) forControlEvents:UIControlEventTouchUpInside];
        [self setAccessoryView:btnDownload];
    }else{
        [self setAccessoryView:nil];
    }
}
- (IBAction)onFavorite:(UIButton*)sender {
    
    [sender pulseToSize:1.2 duration:0.25 repeat:NO];
    NSString *nodeUrl = [_node nodeUrl];
    if ([[_node isAddedToBoomark] boolValue]) {
        Node *node = [Node MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"nodeUrl == %@",nodeUrl] inContext:[NSManagedObjectContext MR_defaultContext]];
        [node MR_deleteEntity];
        [_node setIsAddedToBoomark: [_node.isAddedToBoomark boolValue] ? @0 : @1];
    }else{
        Node *node = [Node MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"nodeUrl == %@",nodeUrl] inContext:[NSManagedObjectContext MR_defaultContext]];
        if (!node) {
            node = [Node MR_createEntity];
            [node setCreatedAt:[NSDate date]];
        }
        [node setUpdatedAt:[NSDate date]];
        [_node setIsAddedToBoomark: [_node.isAddedToBoomark boolValue] ? @0 : @1];
        [node initFromTempNode:_node];
    }
    
    [self configWithNode:_node];
}

-(void) onDownload:(UIButton*) sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(NodeListCustomCell:didTapOnDownload:)]) {
        [self.delegate NodeListCustomCell:self didTapOnDownload:sender];
    }
}
@end
