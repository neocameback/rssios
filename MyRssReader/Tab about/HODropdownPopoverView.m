//
//  HODropdownPopoverView.m
//  MyRssReader
//
//  Created by Huy Nguyen on 11/1/16.
//  Copyright © 2016 Duong Thanh Tung. All rights reserved.
//

#import "HODropdownPopoverView.h"
#import "UIColor+Helper.h"

@interface HODropdownPopoverView ()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) id selectedObject;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) CGSize preferSize;
@property (nonatomic,copy) HODropdownCompletionBlock completionBlock;
@property (nonatomic,copy) HODropdownObjectToStringBlock converterBlock;
@end

@implementation HODropdownPopoverView

- (instancetype)initWithStrings:(NSArray *)strings
                 selectedString:(NSString *)selectedString
                     preferSize:(CGSize)size
                     completion:(HODropdownCompletionBlock)completionBlock {
    self = [super init];
    _data = [strings copy];
    _selectedObject = selectedString;
    _preferSize = size;
    _completionBlock = completionBlock;
    return self;
}
- (instancetype)initWithObjects:(NSArray *)objects
                 selectedObject:(id)selectedObject
                     preferSize:(CGSize)size
        objectToStringConverter:(HODropdownObjectToStringBlock)converter
                     completion:(HODropdownCompletionBlock)completionBlock {
    self = [super init];
    _data = objects;
    _selectedObject = selectedObject;
    _preferSize = size;
    _completionBlock = completionBlock;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.selectedIndex = -1;
    if (self.converterBlock) {
        for (id item in self.data) {
            if ([self.converterBlock(item) isEqualToString:self.converterBlock(self.selectedObject)]) {
                self.selectedIndex = [self.data indexOfObject:item];
                break;
            }
        }
    } else {
        for (id item in self.data) {
            if ([item isEqualToString:self.selectedObject]) {
                self.selectedIndex = [self.data indexOfObject:item];
                break;
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"dropdownCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *cellString = nil;
    if (self.converterBlock) {
        cellString = self.converterBlock(self.data[indexPath.row]);
    } else {
        cellString = self.data[indexPath.row];
    }
    cell.textLabel.text = cellString;
    if (self.selectedIndex == indexPath.row) {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"BA0C34"];
        cell.textLabel.font = [UIFont fontWithName:cellString size:18];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"121018"];
        cell.textLabel.font = [UIFont fontWithName:cellString size:18];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.completionBlock) {
        id item = self.data[indexPath.row];
        self.completionBlock(item,indexPath.row);
    }
}

- (CGSize)preferredContentSize {
    if (self.preferSize.width == 0 && self.preferSize.height == 0) {
        return CGSizeMake(300, 200);
    } else {
        return self.preferSize;
    }
}
@end
