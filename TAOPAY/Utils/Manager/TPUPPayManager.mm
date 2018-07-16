//
//  TPUPPayManager.m
//  TAOPAY
//
//  Created by admin on 2018/5/6.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPUPPayManager.h"

#import "TPURLConfigure.h"

#import <SVProgressHUD/SVProgressHUD.h>

@implementation TPUPPayManager

YSingletonM(UPPayManager)

- (void)startPay:(NSString *)tn
  viewController:(UIViewController *)viewController
   completeBlock:(void(^)(BOOL result))complete {
//    if ([[UPPaymentControl defaultControl] isPaymentAppInstalled]) {
        BOOL tmpPayStatus = [[UPPaymentControl defaultControl] startPay:tn fromScheme:kUNIONPAY_SCHEME mode:kMode_Release viewController:viewController];
        complete(tmpPayStatus);
//    } else {
//        [SVProgressHUD showErrorWithStatus:@"请先安装银联支付的软件"];
//    }
}

- (void)handleUnionPayMentResult:(NSURL *)url
                   completeBlock:(UPPaymentResultBlock)completionBlock {
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        completionBlock(code, data);
    }];
}

@end
