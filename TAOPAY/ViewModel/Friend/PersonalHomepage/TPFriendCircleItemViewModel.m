//
//  TPFriendCircleItemViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/28.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPFriendCircleItemViewModel.h"

#import "TPAppConfig.h"

#import "TPFriendArticleModel.h"

@interface TPFriendCircleItemViewModel ()
@property (readwrite,strong, nonatomic) TPFriendArticleModel *friendArticleModel;
@end

@implementation TPFriendCircleItemViewModel

- (instancetype)initWithGoods:(TPFriendArticleModel *)model {
    if (self = [super init]) {
        self.friendArticleModel = model;
    }
    
    return self;
}

@end
