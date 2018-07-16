//
//  TPURLConfigure.h
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#ifndef TPURLConfigure_h
#define TPURLConfigure_h

#define TAOPAY_BASE_URL  @"http://hanshanghai.net"

#define RegisterRequst  @"api/register"
#define LoginRequst  @"api/login"
#define SMSRequst  @"api/sms"
#define UserInfoRequst  @"api/user/info"
#define BalanceDetailRequst @"api/balance/detail"
#define BalanceRechargeRequst @"api/balance/recharge"
#define BalanceTransferRequst @"api/balance/transfer"
#define BalanceQueryRequst @"api/balance/query"
#define UserUpdateNickRequst @"api/user/updateNick"

//商城相关的接口
#define ShopMainRequst @"api/shop/main"
#define ShopGoodsRequst @"api/shop/goods"
#define ShopGoodsInfoRequst @"api/shop/goodsInfo"
#define ShopCompanyRequst @"api/shop/company"
#define ShopGoodsCollectionRequst @"api/shop/collection"
#define ShopCartRequst @"api/shop/cart"
#define ShopAddCartRequst @"api/shop/addCart"
#define ShopModifyCartRequst @"api/shop/modifyCart"
#define ShopDelCartRequst @"api/shop/delCart"
#define ShopAddressRequst @"api/shop/address"
#define ShopAddAddressRequst @"api/shop/addAddress"
#define ShopModifyAddressRequst @"api/shop/modifyAddress"
#define ShopDelAddressRequst @"api/shop/delAddress"
#define ShopAreaRequst @"api/shop/area"
#define ShopOrderAddRequest  @"api/shop/orderAdd"
#define ShopOrderInfoRequest  @"api/shop/orderInfo"
#define ShopOrderListRequest  @"api/shop/order"
#define UnionpayRnRequest  @"api/unionpay/tn"
#define UnionpayQueryRequest  @"api/unionpay/query"




//请求相关的常量
#define TPRequestPageSize @"10"

//MARK: -- 银联支付配置
#define kUNIONPAY_SCHEME              @"UPTAOPAY"
#define kMode_Development             @"01"
#define kMode_Release                 @"00"
#define kURL_TN_Normal                @"http://101.231.204.84:8091/sim/getacptn"
#define kURL_TN_Configure             @"http://101.231.204.84:8091/sim/app.jsp?user=123456789"

#endif /* TPURLConfigure_h */
