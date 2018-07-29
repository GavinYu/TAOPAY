//
//  TPFriendCircleItemViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/28.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTableViewModel.h"

@class TPFriendArticleModel;

@interface TPFriendCircleItemViewModel : TPTableViewModel

@property (readonly,strong, nonatomic) TPFriendArticleModel *friendArticleModel;

- (instancetype)initWithGoods:(TPFriendArticleModel *)model;

@end
