//
//  TPViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//  所有自定义的视图模型的基类

#import <Foundation/Foundation.h>

#import "TPConstBlock.h"

@class TPUser;

@interface TPViewModel : NSObject


@property (nonatomic, strong) NSURLSessionTask *sessinTask;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) TPUser *user;
/// Initialization method. This is the preferred way to create a new view model.
///
/// params   - The parameters to be passed to view model.
///
/// Returns a new view model.
- (instancetype)initWithParams:(NSDictionary *)params;

/// The `params` parameter in `-initWithParams:` method.
/// The `params` Key's `kBaseViewModelParamsKey`
@property (nonatomic, copy, readonly) NSDictionary *params;
/// 导航栏title
@property (nonatomic, copy) NSString *title;

/// Request data from remote server ，sub class can override it
- (void)loadData:(void(^)(id json))success
         failure:(void (^)(NSError *error))failure;

/// The callback block.
@property (nonatomic, copy) VoidBlock_id callback;
@end
