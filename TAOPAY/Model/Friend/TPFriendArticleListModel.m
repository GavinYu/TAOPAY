//
//  TPFriendArticleListModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/21.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPFriendArticleListModel.h"

@implementation TPFriendArticleListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"list"  : @"TPFriendArticleModel"
             };
}

@end
