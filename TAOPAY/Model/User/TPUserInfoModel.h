//
//  TPUserInfoModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/19.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@interface TPUserInfoModel : YObject

// 用户ID
@property (nonatomic, copy) NSString *userId;
/// 用户名
@property (nonatomic, copy) NSString *username;
//昵称
@property (nonatomic, copy) NSString *nick;
// 简介
@property (nonatomic, copy) NSString *info;
// avatar 头像 50x50
@property (nonatomic, copy) NSString *avatar;

@end
