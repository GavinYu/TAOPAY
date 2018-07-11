//
//  NSString+YValid.h
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YValid)
/// 检测字符串是否包含中文
+( BOOL)y_isContainChinese:(NSString *)str;

/// 整形
+ (BOOL)y_isPureInt:(NSString *)string;

/// 浮点型
+ (BOOL)y_isPureFloat:(NSString *)string;

/// 有效的手机号码
+ (BOOL)y_isValidMobile:(NSString *)str;

/// 纯数字
+ (BOOL)y_isPureDigitCharacters:(NSString *)string;

/// 字符串为字母或者数字
+ (BOOL)y_isValidCharacterOrNumber:(NSString *)str;

@end
