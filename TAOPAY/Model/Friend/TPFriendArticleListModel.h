//
//  TPFriendArticleListModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/21.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@class TPFriendArticleModel;
@class TPUserInfoModel;

@interface TPFriendArticleListModel : YObject

@property (strong, nonatomic) TPUserInfoModel *info;
//好友列表
@property (strong, nonatomic) NSArray <TPFriendArticleModel *>*list;



@end
