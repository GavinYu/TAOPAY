//
//  UIScrollView+YRefresh.h
//  TAOPAY
//
//  Created by admin on 2018/4/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MJRefresh/MJRefresh.h>

@interface UIScrollView (YRefresh)
/// 添加下拉刷新控件
- (MJRefreshNormalHeader *)mh_addHeaderRefresh:(void(^)(MJRefreshNormalHeader *header))refreshingBlock;
/// 添加上拉加载控件
- (MJRefreshAutoNormalFooter *)mh_addFooterRefresh:(void(^)(MJRefreshAutoNormalFooter *footer))refreshingBlock;

@end
