//
//  TPCardOperateViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/4/30.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPCardOperateViewModel.h"

#import "TPWalletCommonModel.h"
#import "TPWalletKeyValueModel.h"
#import "TPRechargeModel.h"
#import "TPAppConfig.h"

@implementation TPCardOperateViewModel

//MARK: -- Getter walletTips
- (NSString *)walletTips {
    NSString *tmpStr;
    switch (_cardOperateType) {
        case TPCardOperateTypeRecharge:
            {
                tmpStr = [NSString stringWithFormat:@"该卡本次最多充值%.2f元", TPRECHARGEMAX];
            }
            break;
            
        case TPCardOperateTypeWithdraw:
        {
            tmpStr = [NSString stringWithFormat:@"可用额度%.2f元", TPRECHARGEMAX];
        }
            break;
            
        case TPCardOperateTypeTransfer:
        {
            tmpStr = @"积分实时转入对方账户，无法退回";
        }
            break;
            
        default:
            tmpStr = @"";
            break;
    }
    
    return tmpStr;
}

//MARK: -- Getter validLogin
- (BOOL)validNextStep {
    if (_cardOperateType == TPCardOperateTypeTransfer) {
        return YStringIsNotEmpty(self.walletKeyValueModel.value) && YStringIsNotEmpty(self.cardKeyValueModel.value);
    } else {
        return YStringIsNotEmpty(self.walletKeyValueModel.value);
    }
}

//MARK: -- Setter
- (void)setCardOperateType:(TPCardOperateType)cardOperateType {
    _cardOperateType = cardOperateType;
    switch (_cardOperateType) {
        case TPCardOperateTypeRecharge:
        {
            self.title = @"充值";
            _walletTips = [NSString stringWithFormat:@"该卡本次最多充值%.2f元", TPRECHARGEMAX];
            _sectionNumber = 2;
            self.rechargeType = @"1";
            
            self.walletKeyValueModel.textFieldPlaceholder = @"请输入充值金额";
            
            //FIXME:TODO ---- TEST
            self.walletCommonModel.icon = @"icon_logo_small";
            self.walletCommonModel.mainTitle = @"淘易付会员卡";
            self.walletCommonModel.subTitle = @"卡号123456789987654321";
            self.walletKeyValueModel.key = @"金额";
        }
            break;
            
        case TPCardOperateTypeWithdraw:
        {
            self.title = @"提现";
            _walletTips = [NSString stringWithFormat:@"可用额度%.2f元", TPRECHARGEMAX];
            self.walletKeyValueModel.textFieldPlaceholder = @"请输入提现金额";
            _sectionNumber = 2;
            //FIXME:TODO ---- TEST
            self.walletCommonModel.icon = @"icon_logo_small";
            self.walletCommonModel.mainTitle = @"新韩银行";
            self.walletCommonModel.subTitle = @"尾号4321";
            self.walletKeyValueModel.key = @"金额";
        }
            break;
            
        case TPCardOperateTypeTransfer:
        {
            self.title = @"转账";
            _walletTips = @"积分实时转入对方账户，无法退回";
            self.walletKeyValueModel.textFieldPlaceholder = @"请输入对方会员卡号";
            self.cardKeyValueModel.textFieldPlaceholder = @"请输入转账金额";
            self.cardKeyValueModel.isHaveImage = YES;
            _sectionNumber = 3;
            //FIXME:TODO ---- TEST
            self.walletCommonModel.icon = @"icon_logo_small";
            self.walletCommonModel.mainTitle = @"淘易付会员卡";
            self.walletCommonModel.subTitle = @"卡号123456789987654321";
            self.walletKeyValueModel.key = @"对方卡号";
            
            self.cardKeyValueModel.key = @"转账金额";
        }
            break;
            
        default:
            break;
    }
}

//MARK: -- lazyload walletCommonModel
- (TPWalletCommonModel *)walletCommonModel {
    if (!_walletCommonModel) {
        _walletCommonModel = TPWalletCommonModel.new;
    }
    
    return _walletCommonModel;
}

//MARK: -- lazyload walletKeyValueModel
- (TPWalletKeyValueModel *)walletKeyValueModel {
    if (!_walletKeyValueModel) {
        _walletKeyValueModel = TPWalletKeyValueModel.new;
    }
    
    return _walletKeyValueModel;
}

//MARK: -- lazyload walletKeyValueModel
- (TPWalletKeyValueModel *)cardKeyValueModel {
    if (!_cardKeyValueModel) {
        _cardKeyValueModel = TPWalletKeyValueModel.new;
    }
    
    return _cardKeyValueModel;
}
//MARK: -- 充值接口
- (void)balanceRechargeSuccess:(void (^)(id json))success failure:(void (^)(NSError *))failure {
    @weakify(self);
    [[YHTTPService sharedInstance] requestBalanceRechargeWithAmount:self.amount  success:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            self.rechargeModel = [TPRechargeModel modelWithDictionary:response.parsedResult];
            success(self.rechargeModel);
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

//MARK: -- 转账接口
- (void)balanceTransferSuccess:(void (^)(id json))success failure:(void (^)(NSError *))failure {
    //    @weakify(self);
    [[YHTTPService sharedInstance] requestBalanceTransferWithAmount:self.amount cardNumber:self.cardNumber transferType:self.transferType success:^(YHTTPResponse *response) {
        //        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            success(response.parsedResult[@"balance"]);
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

//查询支付结果接口
- (void)balanceQuerySuccess:(void (^)(id json))success failure:(void (^)(NSError *))failure {
//    @weakify(self);
    [[YHTTPService sharedInstance] requestBalanceQueryWithOrderId:self.rechargeModel.orderId type:self.rechargeType success:^(YHTTPResponse *response) {
//        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            success(response.parsedResult);
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

@end
