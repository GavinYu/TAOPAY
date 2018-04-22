//
//  SAMKeychain+YUtil.m
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "SAMKeychain+YUtil.h"

#import <UIKit/UIKit.h>

/// 登录账号的key
static NSString *const Y_RAW_LOGIN = @"YRawLogin";
static NSString *const Y_SERVICE_NAME_IN_KEYCHAIN = @"com.taopay.TaoPay";
static NSString *const Y_DEVICEID_ACCOUNT         = @"DeviceID";

@implementation SAMKeychain (YUtil)
+ (NSString *)rawLogin {
  return [[NSUserDefaults standardUserDefaults] objectForKey:Y_RAW_LOGIN];
}
+ (BOOL)setRawLogin:(NSString *)rawLogin {
  if (rawLogin == nil) NSLog(@"+setRawLogin: %@", rawLogin);
  
  [[NSUserDefaults standardUserDefaults] setObject:rawLogin forKey:Y_RAW_LOGIN];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  return YES;
}
+ (BOOL)deleteRawLogin {
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:Y_RAW_LOGIN];
  [[NSUserDefaults standardUserDefaults] synchronize];
  return YES;
}


+ (NSString *)deviceId{
  NSString * deviceidStr = [SAMKeychain passwordForService:Y_SERVICE_NAME_IN_KEYCHAIN account:Y_DEVICEID_ACCOUNT];
  if (deviceidStr == nil) {
    deviceidStr = [UIDevice currentDevice].identifierForVendor.UUIDString;
    [SAMKeychain setPassword:deviceidStr forService:Y_SERVICE_NAME_IN_KEYCHAIN account:Y_DEVICEID_ACCOUNT];
  }
  return deviceidStr;
}
@end

