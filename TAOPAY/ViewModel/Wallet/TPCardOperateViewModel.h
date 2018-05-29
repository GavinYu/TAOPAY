//
//  TPCardOperateViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/4/30.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPViewModel.h"

@class TPWalletCommonModel;
@class TPWalletKeyValueModel;
@class TPRechargeModel;

typedef NS_ENUM(NSInteger, TPCardOperateType) {
    TPCardOperateTypeRecharge,
    TPCardOperateTypeWithdraw,
    TPCardOperateTypeTransfer
};

@interface TPCardOperateViewModel : TPViewModel

/// 下一步按钮的点击状态
@property (nonatomic, readonly, assign) BOOL validNextStep;
/// 卡的信息
@property (nonatomic, strong)  TPWalletCommonModel *walletCommonModel;
/// 金额及值
@property (nonatomic, strong) TPWalletKeyValueModel *walletKeyValueModel;
/// 卡操作的类型
@property (nonatomic, assign) TPCardOperateType cardOperateType;
/// 卡及卡号
@property (nonatomic, strong) TPWalletKeyValueModel *cardKeyValueModel;
//充值返回数据模型
@property (nonatomic, strong) TPRechargeModel *rechargeModel;
///table 的sectionview 提示语
@property (nonatomic, copy) NSString *walletTips;
///table 的section
@property (nonatomic, assign) NSInteger sectionNumber;
//金额
@property (nonatomic, copy) NSString *amount;
//转账-收账的卡号
@property (nonatomic, copy) NSString *cardNumber;
//转账类型(默认：0:会员之间转账)
@property (nonatomic, copy) NSString *transferType;
//充值类型(默认：1:银联)
@property (nonatomic, copy) NSString *rechargeType;

//充值接口
- (void)balanceRechargeSuccess:(void (^)(id json))success failure:(void (^)(NSError *errorMsg))failure;
//转账接口
- (void)balanceTransferSuccess:(void (^)(id json))success failure:(void (^)(NSError *errorMsg))failure;
//查询支付结果接口
- (void)balanceQuerySuccess:(void (^)(id json))success failure:(void (^)(NSError *errorMsg))failure;

@end
