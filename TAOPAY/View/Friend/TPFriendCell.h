//
//  TPFriendCell.h
//  TAOPAY
//
//  Created by admin on 2018/5/6.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YBaseTableViewCell.h"

@class TPFriendCell;
/**
 * 关注 被点击
 */
typedef void(^TPFriendCellAttentionClickedHandler)(TPFriendCell *friendCell);

@interface TPFriendCell : YBaseTableViewCell

@property (nonatomic, copy) TPFriendCellAttentionClickedHandler attentionClickedHandler;

@end
