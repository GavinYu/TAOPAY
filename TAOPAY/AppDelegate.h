//
//  AppDelegate.h
//  TAOPAY
//
//  Created by admin on 2018/4/10.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YNavigationControllerStack.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/// APP管理的导航栏的堆栈
@property (nonatomic, readonly, strong) YNavigationControllerStack *navigationControllerStack;

/// 获取AppDelegate
+ (AppDelegate *)sharedDelegate;

@end

