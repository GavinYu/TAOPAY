//
//  YBaseTableViewCell.h
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YReactiveView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YBaseTableViewCell : UITableViewCell <YReactiveView>

/**
 *  初始化Cell
 *
 *  @param tableView cell所处的tableview
 *
 *  @return Cell
 */
+ (instancetype)cellForTableView:(UITableView *)tableView;

/**
 *  根据数据源显示Cell的内容
 *
 *  @param dataSources 数据源
 *  @param indexPath   Cell所处的IndexPath
 */
- (void)displayCellByDataSources:(nullable id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
