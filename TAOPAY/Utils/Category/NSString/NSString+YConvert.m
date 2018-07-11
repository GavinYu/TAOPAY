//
//  NSString+YConvert.m
//  TAOPAY
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "NSString+YConvert.h"

#import "TPMacros.h"

@implementation NSString (YConvert)

+ (NSString *)integerToString:(NSInteger)integer {
    return [NSString stringWithFormat:@"%li", (long)integer];
}

+ (NSString *)getStringFromString:(NSString *)str {
    return YStringIsNotEmpty(str)?str:@"";
}


@end
