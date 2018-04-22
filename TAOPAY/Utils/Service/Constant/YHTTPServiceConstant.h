//
//  YHTTPServiceConstant.h
//  TAOPAY
//
//  Created by admin on 2018/4/13.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#ifndef YHTTPServiceConstant_h
#define YHTTPServiceConstant_h

/// 服务器相关
#define YHTTPRequestTokenKey @"token"

/// 私钥key
#define YHTTPServiceKey  @"privatekey"
/// 私钥Value
#define YHTTPServiceKeyValue @"/** 你的私钥 **/"

/// 签名key
#define YHTTPServiceSignKey @"sign"

/// 服务器返回的三个固定字段
/// 状态码key
#define YHTTPServiceResponseCodeKey     @"code"
/// 状态码status
#define YHTTPServiceResponseStatusKey   @"status"
/// 消息key
#define YHTTPServiceResponseMsgKey      @"message"
/// 数据data
#define YHTTPServiceResponseDataKey     @"data"
/// 数据data{"list":[]}
#define YHTTPServiceResponseDataListKey @"list"

#endif /* YHTTPServiceConstant_h */
