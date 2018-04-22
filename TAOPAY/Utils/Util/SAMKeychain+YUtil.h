//
//  SAMKeychain+YUtil.h
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "SAMKeychain.h"

@interface SAMKeychain (YUtil)

+ (NSString *)rawLogin ;

+ (BOOL)setRawLogin:(NSString *)rawLogin ;

+ (BOOL)deleteRawLogin;
/// 设备ID or UUID
+ (NSString *)deviceId;

@end
