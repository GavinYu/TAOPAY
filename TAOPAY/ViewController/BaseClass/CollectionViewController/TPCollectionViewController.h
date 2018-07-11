//
//  TPCollectionViewController.h
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPBaseViewController.h"

#import "UIScrollView+YRefresh.h"

@interface TPCollectionViewController : TPBaseViewController <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/// The collection view for collectionView controller.
/// tableView
@property (nonatomic, readonly, weak) UICollectionView *collectionView;
/// 内容缩进
@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

/// reload collectionView data , sub class can override
- (void)reloadData;

/// duqueueReusavleCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/// configure cell data
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

/// 下拉刷新事件
- (void)collectionViewDidTriggerHeaderRefresh;
/// 上拉加载事件
- (void)collectionViewDidTriggerFooterRefresh;

/**
 哪个刷新事件完成
 @param isHeader 是否是下拉刷新结束
 @param reload 是否需要刷新数据
 */
- (void)collectionViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;

@end
