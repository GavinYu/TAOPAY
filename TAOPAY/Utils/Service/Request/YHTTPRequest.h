//
//  YHTTPRequest.h
//  TAOPAY
//
//  Created by admin on 2018/4/13.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

//  网络服务层 - 请求

#import <Foundation/Foundation.h>

#import "YURLParameters.h"
#import "RACSignal+HTTPServiceAdditions.h"

@interface YHTTPRequest : NSObject
/// 请求参数
@property (nonatomic, readonly, strong) YURLParameters *urlParameters;
/**
 获取请求类
 @param params  参数模型
 @return 请求类
 */
+(instancetype)requestWithParameters:(YURLParameters *)parameters;

@end
/// MHHTTPService的分类
@interface YHTTPRequest (YHTTPService)
/// 入队
- (RACSignal *) enqueueResultClass:(Class /*subclass of YObject*/) resultClass;
@end
