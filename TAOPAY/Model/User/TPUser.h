//
//  TPUser.h
//  TAOPAY
//
//  Created by admin on 2018/4/13.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//  用户信息模型

#import "YObject.h"

#import <UIKit/UIKit.h>
#import "TPConstEnum.h"

@interface TPUser : YObject

// token
@property (nonatomic, readwrite, copy) NSString *token;

// avatar 头像 50x50
@property (nonatomic, readwrite, strong) NSURL *avatar;
// 余额
@property (nonatomic, readwrite, copy) NSString *balance;
//会员卡号
@property (nonatomic, readwrite, copy) NSString *cardNum;
//注册日期
@property (nonatomic, readwrite, copy) NSString *created_at;
// 邮箱
@property (nonatomic, readwrite, copy) NSString *email;
// 简介
@property (nonatomic, readwrite, copy) NSString *info;
//昵称
@property (nonatomic, readwrite, copy) NSString *nick;
// 积分
@property (nonatomic, readwrite, copy) NSString *point;
/// 用户名
@property (nonatomic, readwrite, copy) NSString *username;

@end
