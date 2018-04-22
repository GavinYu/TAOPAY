//
//  RACSignal+HTTPServiceAdditions.h
//  TAOPAY
//
//  Created by admin on 2018/4/13.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "RACSignal.h"

@interface RACSignal (HTTPServiceAdditions)

// This method assumes that the receiver is a signal of YHTTPResponses.
//
// Returns a signal that maps the receiver to become a signal of
// YHTTPResponses.parsedResult.
- (RACSignal *)mh_parsedResults;

@end
