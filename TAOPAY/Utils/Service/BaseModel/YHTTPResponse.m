//
//  YHTTPResponse.m
//  TAOPAY
//
//  Created by admin on 2018/4/13.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YHTTPResponse.h"

#import "YHTTPServiceConstant.h"

@interface YHTTPResponse ()

/// The parsed YObject object corresponding to the API response.
/// The developer need care this data
@property (nonatomic, readwrite, strong) id parsedResult;
/// 自己服务器返回的状态码
@property (nonatomic, readwrite, assign) YHTTPResponseCode code;
/// 自己服务器返回的信息
@property (nonatomic, readwrite, copy) NSString *message;

@end

@implementation YHTTPResponse

- (instancetype)initWithResponseObject:(id)responseObject parsedResult:(id)parsedResult
{
  self = [super init];
  if (self) {
    self.parsedResult = parsedResult ?:NSNull.null;
    self.code = [responseObject[YHTTPServiceResponseCodeKey] integerValue];
    self.message = responseObject[YHTTPServiceResponseMsgKey];
  }
  return self;
}
@end


