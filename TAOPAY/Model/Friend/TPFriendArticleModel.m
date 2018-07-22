//
//  TPFriendArticleModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/21.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPFriendArticleModel.h"

@implementation TPFriendArticleModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"articleId":@"id",
             @"content":@"content",
             @"avatar":@"avatar",
             @"nick":@"nick",
             @"time":@"time",
             @"files":@"files"
             };
}

@end
