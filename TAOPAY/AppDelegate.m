//
//  AppDelegate.m
//  TAOPAY
//
//  Created by admin on 2018/4/10.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "AppDelegate.h"

#import "HomepageViewController.h"
#import "TPLoginViewModel.h"
#import "YNewFeatureViewModel.h"
#import "YBaseNavigationController.h"
#import "TPTabBarViewController.h"
#import "RootViewController.h"
#import "TPAppConfig.h"

#import "TPUPPayManager.h"
#import "RSA.h"
#import <CommonCrypto/CommonDigest.h>
#import "YHTTPService.h"

#import "EaseUI.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //设置程序第一次启动后的值
    if (![[YUtil getUserDefaultInfo:TPAppEverLaunchKey] boolValue]) {
        [YUtil saveUserDefaultInfo:[NSNumber numberWithBool:YES] forKey:TPAppEverLaunchKey];
        [YUtil saveUserDefaultInfo:[NSNumber numberWithBool:YES] forKey:TPAppFirstLaunchKey];
    } else {
        [YUtil saveUserDefaultInfo:[NSNumber numberWithBool:NO] forKey:TPAppFirstLaunchKey];
    }
    
    //初始化环信SDK
    [self initEasyMobSDK];
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:EasyMobSDKAppKey
                                         apnsCertName:@""
                                          otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

//MARK: -- App 进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //环信SDK
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

//MARK: -- App 将要进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //环信SDK
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    [[TPUPPayManager sharedUPPayManager] handleUnionPayMentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        BOOL tmpResult = NO;
        if([code isEqualToString:@"success"]) {
            tmpResult = YES;
            //如果想对结果数据验签，可使用下面这段代码，但建议不验签，直接去商户后台查询交易结果
//            if(data != nil){
//                //数据从NSDictionary转换为NSString
//                NSData *signData = [NSJSONSerialization dataWithJSONObject:data
//                                                                   options:0
//                                                                     error:nil];
//                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
//
//                //此处的verify建议送去商户后台做验签，如要放在手机端验，则代码必须支持更新证书
//                if([self verify:sign]) {
//                    //验签成功
//                }
//                else {
//                    //验签失败
//                }
//            }
            
            //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
            
        } else if([code isEqualToString:@"fail"]) {
            //交易失败
        } else if([code isEqualToString:@"cancel"]) {
            //交易取消
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TPPayResultNotificationKey object:[NSNumber numberWithBool:tmpResult] userInfo:data];
    }];
    
    return YES;
}


- (NSString*)sha1:(NSString *)string
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_CTX context;
    NSString *description;
    
    CC_SHA1_Init(&context);
    
    memset(digest, 0, sizeof(digest));
    
    description = @"";
    
    
    if (string == nil)
    {
        return nil;
    }
    
    // Convert the given 'NSString *' to 'const char *'.
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    // Check if the conversion has succeeded.
    if (str == NULL)
    {
        return nil;
    }
    
    // Get the length of the C-string.
    int len = (int)strlen(str);
    
    if (len == 0)
    {
        return nil;
    }
    
    
    if (str == NULL)
    {
        return nil;
    }
    
    CC_SHA1_Update(&context, str, len);
    
    CC_SHA1_Final(digest, &context);
    
    description = [NSString stringWithFormat:
                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[ 0], digest[ 1], digest[ 2], digest[ 3],
                   digest[ 4], digest[ 5], digest[ 6], digest[ 7],
                   digest[ 8], digest[ 9], digest[10], digest[11],
                   digest[12], digest[13], digest[14], digest[15],
                   digest[16], digest[17], digest[18], digest[19]];
    
    return description;
}

- (NSString *) readPublicKey:(NSString *) keyName
{
    if (keyName == nil || [keyName isEqualToString:@""]) return nil;
    
    NSMutableArray *filenameChunks = [[keyName componentsSeparatedByString:@"."] mutableCopy];
    NSString *extension = filenameChunks[[filenameChunks count] - 1];
    [filenameChunks removeLastObject]; // remove the extension
    NSString *filename = [filenameChunks componentsJoinedByString:@"."]; // reconstruct the filename with no extension
    
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
    
    NSString *keyStr = [NSString stringWithContentsOfFile:keyPath encoding:NSUTF8StringEncoding error:nil];
    
    return keyStr;
}

-(BOOL) verify:(NSString *) resultStr {
    
    //此处的verify，商户需送去商户后台做验签
    return NO;
}

//-(BOOL) verifyLocal:(NSString *) resultStr {
//
//    //从NSString转化为NSDictionary
//    NSData *resultData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
//
//    //获取生成签名的数据
//    NSString *sign = data[@"sign"];
//    NSString *signElements = data[@"data"];
//    //NSString *pay_result = signElements[@"pay_result"];
//    //NSString *tn = signElements[@"tn"];
//    //转换服务器签名数据
//    NSData *nsdataFromBase64String = [[NSData alloc]
//                                      initWithBase64EncodedString:sign options:0];
//    //生成本地签名数据，并生成摘要
////    NSString *mySignBlock = [NSString stringWithFormat:@"pay_result=%@tn=%@",pay_result,tn];
//    NSData *dataOriginal = [[self sha1:signElements] dataUsingEncoding:NSUTF8StringEncoding];
//    //验证签名
//    //TODO：此处如果是正式环境需要换成public_product.key
//    NSString *pubkey =[self readPublicKey:@"public_test.key"];
//    OSStatus result=[RSA verifyData:dataOriginal sig:nsdataFromBase64String publicKey:pubkey];
//
//
//
//    //签名验证成功，商户app做后续处理
//    if(result == 0) {
//        //支付成功且验签成功，展示支付成功提示
//        return YES;
//    }
//    else {
//        //验签失败，交易结果数据被篡改，商户app后台查询交易结果
//        return NO;
//    }
//
//    return NO;
//}

//MARK: -- 环信sdk
//MARK: -- 初始化环信SDK
- (void)initEasyMobSDK {
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:EasyMobSDKAppKey];
    [[EMClient sharedClient] initializeSDKWithOptions:options];
}

#pragma mark- 获取appDelegate
+ (AppDelegate *)sharedDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
