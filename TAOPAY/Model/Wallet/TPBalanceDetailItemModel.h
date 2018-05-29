//
//  TPBalanceDetailItemModel.h
//  TAOPAY
//
//  Created by admin on 2018/5/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@interface TPBalanceDetailItemModel : YObject
//金额
@property (copy, nonatomic) NSString *amount;
//内容
@property (copy, nonatomic) NSString *content;
//类型（充值-0、提现-1、转账-2）
@property (copy, nonatomic) NSString *type;
//创建时间
@property (copy, nonatomic) NSString *created_at;

@end
