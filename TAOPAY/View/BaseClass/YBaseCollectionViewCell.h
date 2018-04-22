//
//  YBaseCollectionViewCell.h
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBaseCollectionViewCell : UICollectionViewCell

/**
 *  初始化Cell
 *
 *  @param collectionView cell所处的UICollectionView
 *
 *  @return Cell
 */
+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  根据数据源显示Cell的内容
 *
 *  @param dataSources 数据源
 *  @param indexPath   Cell所处的IndexPath
 */
- (void)displayCellByDataSources:(id)dataSources itemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
