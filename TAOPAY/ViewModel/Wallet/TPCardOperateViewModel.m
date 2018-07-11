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
                tmpStr = TPLocalizedString(@"wallet_recharge_tips");
//                [NSString stringWithFormat:@"该卡本次最多充值%.2f元", TPRECHARGEMAX];
            }
            break;
            
        case TPCardOperateTypeWithdraw:
        {
            tmpStr =  TPLocalizedString(@"wallet_enable_limit");
//            [NSString stringWithFormat:@"可用额度%.2f元", TPRECHARGEMAX];
        }
            break;
            
        case TPCardOperateTypeTransfer:
        {
            tmpStr =TPLocalizedString(@"wallet_integral_transfer_tips");
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
            self.title = TPLocalizedString(@"wallet_recharge");
//            _walletTips = [NSString stringWithFormat:@"该卡本次最多充值%.2f元", TPRECHARGEMAX];
            _walletTips = TPLocalizedString(@"wallet_recharge_tips");
            _sectionNumber = 2;
            self.rechargeType = @"1";
            
            self.walletKeyValueModel.textFieldPlaceholder =TPLocalizedString(@"wallet_input_recharge_money");
            
            //FIXME:TODO ---- TEST
            self.walletCommonModel.icon = @"icon_logo_small";
            self.walletCommonModel.mainTitle = TPLocalizedString(@"wallet_taoyifu_club_card");
            self.walletCommonModel.subTitle = [NSString stringWithFormat:@"%@%@", TPLocalizedString(@"wallet_carnumber"), [YHTTPService sharedInstance].currentUser.cardNum];
            self.walletKeyValueModel.key =TPLocalizedString(@"wallet_money");
        }
            break;
            
        case TPCardOperateTypeWithdraw:
        {
            self.title = TPLocalizedString(@"wallet_withdraw");
            _walletTips = TPLocalizedString(@"wallet_enable_limit");
//            [NSString stringWithFormat:@"可用额度%.2f元", TPRECHARGEMAX];
            
            self.walletKeyValueModel.textFieldPlaceholder = TPLocalizedString(@"wallet_input_withdraw_money");
            _sectionNumber = 2;
            //FIXME:TODO ---- TEST
            self.walletCommonModel.icon = @"icon_logo_small";
            self.walletCommonModel.mainTitle = TPLocalizedString(@"wallet_xinhan_bank");
            self.walletCommonModel.subTitle = TPLocalizedString(@"wallet_end_number");
            self.walletKeyValueModel.key =  TPLocalizedString(@"wallet_money");
        }
            break;
            
        case TPCardOperateTypeTransfer:
        {
            self.title = TPLocalizedString(@"wallet_transfer");
            _walletTips = TPLocalizedString(@"wallet_integral_transfer_tips");
            self.walletKeyValueModel.textFieldPlaceholder =TPLocalizedString(@"wallet_input_other_cardnumber");
            self.cardKeyValueModel.textFieldPlaceholder = TPLocalizedString(@"wallet_input_transfer_money");
            self.cardKeyValueModel.isHaveImage = YES;
            _sectionNumber = 3;
            //FIXME:TODO ---- TEST
            self.walletCommonModel.icon = @"icon_logo_small";
            self.walletCommonModel.mainTitle = TPLocalizedString(@"wallet_taoyifu_club_card");
            self.walletCommonModel.subTitle = [NSString stringWithFormat:@"%@%@", TPLocalizedString(@"wallet_carnumber"), [YHTTPService sharedInstance].currentUser.cardNum] ;
            self.walletKeyValueModel.key = TPLocalizedString(@"wallet_other_carnumber");
            
            self.cardKeyValueModel.key =TPLocalizedString(@"wallet_transfer_money");
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

//MARK: -- lazyload walletKeyValueModel
- (TPRechargeModel *)rechargeModel {
    if (!_rechargeModel) {
        _rechargeModel = TPRechargeModel.new;
    }
    
    return _rechargeModel;
}

//MARK: -- 充值接口
- (void)balanceRechargeSuccess:(void (^)(id json))success failure:(void (^)(NSError *))failure {
    @weakify(self);
    [[YHTTPService sharedInstance] requestBalanceRechargeWithAmount:self.amount  success:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            self.rechargeModel = [TPRechargeModel modelWithDictionary:response.parsedResult];
            success(self.rechargeModel.tn);
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
