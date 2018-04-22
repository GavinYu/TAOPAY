//
//  YBaseTableViewCell.m
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@implementation YBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (instancetype)cellForTableView:(UITableView *)tableView{
    return [[YBaseTableViewCell alloc] init];
}

- (void)displayCellByDataSources:(nullable id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end

NS_ASSUME_NONNULL_END
