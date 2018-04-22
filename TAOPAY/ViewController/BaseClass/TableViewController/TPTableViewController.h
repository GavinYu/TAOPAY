//
//  TPTableViewController.h
//  TAOPAY
//
//  Created by admin on 2018/4/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPBaseViewController.h"

#import "TPTableViewModel.h"
#import "UIScrollView+YRefresh.h"

@interface TPTableViewController : TPBaseViewController <UITableViewDataSource, UITableViewDelegate>
/// The table view for tableView controller.
/// tableView
@property (nonatomic, readonly, weak) UITableView *tableView;
/// 内容缩进
@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

/// reload tableView data , sub class can override
- (void)reloadData;

/// duqueueReusavleCell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/// configure cell data
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

/// 下拉刷新事件
- (void)tableViewDidTriggerHeaderRefresh;
/// 上拉加载事件
- (void)tableViewDidTriggerFooterRefresh;

/**
 哪个刷新事件完成
 @param isHeader 是否是下拉刷新结束
 @param reload 是否需要刷新数据
 */
- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;

@end
