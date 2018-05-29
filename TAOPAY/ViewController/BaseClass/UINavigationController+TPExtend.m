//
//  UINavigationController+TPExtend.m
//  TAOPAY
//
//  Created by admin on 2018/5/27.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "UINavigationController+TPExtend.h"

#import <objc/runtime.h>

const void *s_isShowBackButton = "s_isShowBackButton";
const void *s_navigationType = "s_navigationType";


@implementation UINavigationController (TPExtend)

@dynamic isShowBackButton;
@dynamic navigationType;

- (void)setIsShowBackButton:(BOOL)isShowBackButton {
    objc_setAssociatedObject(self, s_isShowBackButton, [NSNumber numberWithBool:isShowBackButton], OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isShowBackButton {
    return [objc_getAssociatedObject(self, s_isShowBackButton) boolValue];
}

- (void)setNavigationType:(TPNavigationType)navigationType {
    objc_setAssociatedObject(self, s_navigationType, [NSNumber numberWithInteger:navigationType], OBJC_ASSOCIATION_ASSIGN);
}
- (TPNavigationType)navigationType {
    return [objc_getAssociatedObject(self, s_navigationType) integerValue];
}

@end
