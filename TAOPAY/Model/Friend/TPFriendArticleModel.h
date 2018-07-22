//
//  TPFriendArticleModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/21.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@interface TPFriendArticleModel : YObject

@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSArray <NSString *> *files;




@end
