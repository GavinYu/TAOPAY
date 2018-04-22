//
//  YHTTPRequest.m
//  TAOPAY
//
//  Created by admin on 2018/4/13.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YHTTPRequest.h"

#import "YHTTPService.h"

@interface YHTTPRequest ()
/// 请求参数
@property (nonatomic, readwrite, strong) YURLParameters *urlParameters;

@end

@implementation YHTTPRequest

+(instancetype)requestWithParameters:(YURLParameters *)parameters{
  return [[self alloc] initRequestWithParameters:parameters];
}

-(instancetype)initRequestWithParameters:(YURLParameters *)parameters{
  
  self = [super init];
  if (self) {
    self.urlParameters = parameters;
  }
  return self;
}


@end

/// 网络服务层分类 方便YHTTPRequest 主动发起请求
@implementation YHTTPRequest (YHTTPService)

@end


