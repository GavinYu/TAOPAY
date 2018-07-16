//
//  TPUPPayManager.h
//  TAOPAY
//
//  Created by admin on 2018/5/6.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YSingleton.h"
#import <UIKit/UIKit.h>

//UPPay
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UPPaymentControl.h"

@interface TPUPPayManager : NSObject

YSingletonH(UPPayManager)

- (void)startPay:(NSString *)tn
  viewController:(UIViewController *)viewController
   completeBlock:(void(^)(BOOL result))complete;

- (void)handleUnionPayMentResult:(NSURL *)url
                   completeBlock:(UPPaymentResultBlock)completionBlock;

@end
