//
//  YKeyedSubscript.h
//  TAOPAY
//
//  Created by admin on 2018/4/13.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//  参数

#import <Foundation/Foundation.h>

@interface YKeyedSubscript : NSObject
/// 类方法
+ (instancetype) subscript;
/// 拼接一个字典
+ (instancetype)subscriptWithDictionary:(NSDictionary *) dict;
-(instancetype)initWithDictionary:(NSDictionary *) dict;
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

/// 转换为字典
- (NSDictionary *)dictionary;
@end
