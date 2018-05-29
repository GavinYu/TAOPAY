//
//  YBaseCollectionViewCell.m
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@implementation YBaseCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [[YBaseCollectionViewCell alloc] init];
}

- (void)displayCellByDataSources:(id)dataSources itemAtIndexPath:(NSIndexPath *)indexPath {
    
}

// 以下 MVVM使用的场景，如果使用MVC的请自行ignore
#pragma mark - bind data
- (void)bindViewModel:(id)viewModel {
    
}


@end

NS_ASSUME_NONNULL_END
