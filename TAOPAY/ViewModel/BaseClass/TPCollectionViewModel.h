//
//  TPCollectionViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPViewModel.h"

@interface TPCollectionViewModel : TPViewModel

/// The data source of table view.
@property (nonatomic, readwrite, strong) NSMutableArray *dataSource;

/// 是否下拉刷新 default is no
@property (nonatomic, readwrite, assign , getter = isPullDown) BOOL pullDown;
/** 下来刷新 defalut is NO*/
@property (nonatomic, readwrite, assign) BOOL shouldPullDownToRefresh;
/** 上拉加载 defalut is NO*/
@property (nonatomic, readwrite, assign) BOOL shouldPullUpToLoadMore;
/// 是否数据是多段 (It's effect tableView's dataSource 'numberOfSectionsInTableView:') defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldMultiSections;
/// 当前页 defalut is 1
@property (nonatomic, readwrite, assign) NSUInteger page;
/// 每一页的数据 defalut is 20
@property (nonatomic, readwrite, assign) NSUInteger perPage;
/// 最后一页 defalut is 1
@property (nonatomic, readwrite, assign) NSUInteger lastPage;

/**
 * 加载网络数据 通过block回调减轻view 对 viewModel 的状态的监听
 @param success 成功的回调
 @param failure 失败的回调
 @param configFooter 底部刷新控件的状态 lastPage = YES ，底部刷新控件hidden，反之，show
 */
- (void)loadData:(void(^)(id json))success
         failure:(void(^)(NSError *error))failure
    configFooter:(void(^)(BOOL isLastPage))configFooter;
/// 获取本地数据库信息
- (id)fetchLocalData;
/// 数据偏移量
- (NSUInteger)offsetForPage:(NSUInteger)page;

@end
