//
//  HODropdownPopoverView.h
//  MyRssReader
//
//  Created by Huy Nguyen on 11/1/16.
//  Copyright © 2016 Duong Thanh Tung. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HODropdownCompletionBlock)(id item, NSInteger index);
typedef NSString *(^HODropdownObjectToStringBlock)(id object);

@interface HODropdownPopoverView : UITableViewController

- (instancetype)initWithStrings:(NSArray *)strings
                 selectedString:(NSString *)selectedString
                     preferSize:(CGSize)size
                     completion:(HODropdownCompletionBlock)completionBlock;
- (instancetype)initWithObjects:(NSArray *)objects
                 selectedObject:(id)selectedObject
                     preferSize:(CGSize)size
        objectToStringConverter:(HODropdownObjectToStringBlock)converter
                     completion:(HODropdownCompletionBlock)completionBlock;

@end
