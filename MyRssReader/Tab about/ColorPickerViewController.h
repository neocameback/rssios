//
//  ColorPickerViewController.h
//  MyRssReader
//
//  Created by Huy Nguyen on 11/3/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ColorPickerChangedBlock)(id sender, NSString *hexa);

@interface ColorPickerViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, copy) ColorPickerChangedBlock colorPickedBlock;
@end
