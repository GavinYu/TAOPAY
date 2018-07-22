//
//  TPPersonalHomepageCell.h
//  TAOPAY
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YBaseTableViewCell.h"

@class TPPersonalHomepageCell;
/**
 * 头像 被点击
 */
typedef void(^TPCellAvatarTapHandler)(TPPersonalHomepageCell *personalHomepageCell);

@interface TPPersonalHomepageCell : YBaseTableViewCell

@property (nonatomic, copy) TPCellAvatarTapHandler avatarTapBlock;
@property (readonly, copy, nonatomic) NSString *userId;

@end
