//
//  RACSignal+HTTPServiceAdditions.m
//  TAOPAY
//
//  Created by admin on 2018/4/13.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "RACSignal+HTTPServiceAdditions.h"

#import "YHTTPResponse.h"

@implementation RACSignal (HTTPServiceAdditions)

- (RACSignal *)mh_parsedResults {
  return [self map:^(YHTTPResponse *response) {
    NSAssert([response isKindOfClass:YHTTPResponse.class], @"Expected %@ to be an MHHTTPResponse.", response);
    return response.parsedResult;
  }];
}

@end
