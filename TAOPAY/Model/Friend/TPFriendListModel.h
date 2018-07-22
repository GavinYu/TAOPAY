//
//  TPFriendListModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@class TPFriendModel;
@class TPUserInfoModel;

@interface TPFriendListModel : YObject

@property (strong, nonatomic) TPUserInfoModel *info;
//好友列表
@property (strong, nonatomic) NSArray <TPFriendModel *>*list;

@end
