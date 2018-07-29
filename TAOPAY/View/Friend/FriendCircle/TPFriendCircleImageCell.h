//
//  TPFriendCircleImageCell.h
//  TAOPAY
//
//  Created by admin on 2018/7/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YBaseCollectionViewCell.h"

@class TPFriendCircleImageCell;

typedef void(^TPClickAddEventHandler)(TPFriendCircleImageCell *sender);

@interface TPFriendCircleImageCell : YBaseCollectionViewCell

@property (weak, nonatomic) TPClickAddEventHandler addImageBlock;

@property (assign, nonatomic) BOOL addButtonEnable;

@end
