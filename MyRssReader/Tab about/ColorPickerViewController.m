//
//  ColorPickerViewController.m
//  MyRssReader
//
//  Created by Huy Nguyen on 11/3/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "ColorPickerViewController.h"
#import "ColorPickerCollectionViewCell.h"

static NSString *identifier = @"ColorPickerCollectionViewCell";

@interface ColorPickerViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *colors;
@end

@implementation ColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _colors = @[@"ffffff", @"000000", @"BA0C34", @"00c800", @"0000c8", @"eedc00", @"d60080", @"009fda"];
    [_collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil]
      forCellWithReuseIdentifier:identifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onColorChanged:(id)sender {
    
}

- (CGSize)preferredContentSize {
    return CGSizeMake(210, 110);
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colors.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ColorPickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                                    forIndexPath:indexPath];
    cell.colorView.backgroundColor = [UIColor colorWithHexString:self.colors[indexPath.row]];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.colorPickedBlock) {
        self.colorPickedBlock(self, self.colors[indexPath.row]);
    }
}
@end
