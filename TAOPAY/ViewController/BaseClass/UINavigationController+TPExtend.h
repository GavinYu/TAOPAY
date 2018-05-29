//
//  UINavigationController+TPExtend.h
//  TAOPAY
//
//  Created by admin on 2018/5/27.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TPConstEnum.h"

@interface UINavigationController (TPExtend)

@property (nonatomic, assign) BOOL isShowBackButton;
@property (nonatomic, assign) TPNavigationType navigationType;

@end
