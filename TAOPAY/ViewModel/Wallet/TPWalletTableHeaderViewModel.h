//
//  TPWalletTableHeaderViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/4/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPViewModel.h"

@interface TPWalletTableHeaderViewModel : TPViewModel

@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *nickName;

//用户更新用户名接口
- (void)userUpdateNickSuccess:(void (^)(id json))success failure:(void (^)(NSError *errorMsg))failure;

- (void)loadUserInfoSuccess:(void (^)(id json))success failure:(void (^)(NSError *errorMsg))failure;

@end
