//
//  FriendCircleCell.h
//  TAOPAY
//
//  Created by admin on 2018/7/19.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YBaseTableViewCell.h"

@class FriendCircleCell;
@class TPFriendCircleItemViewModel;

typedef void(^TPFriendArticleCellAvatarHandler)(FriendCircleCell *cell);

@interface FriendCircleCell : YBaseTableViewCell

@property (copy, nonatomic) TPFriendArticleCellAvatarHandler tapAvatarBlock;

@property (nonatomic, readonly, strong) TPFriendCircleItemViewModel *viewModel;

@end
