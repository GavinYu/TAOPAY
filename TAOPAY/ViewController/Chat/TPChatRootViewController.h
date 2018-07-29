//
//  TPChatRootViewController.h
//  TAOPAY
//
//  Created by admin on 2018/7/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPBaseViewController.h"

#define TPMsgTableViewWidth     95.0

typedef void(^TPSelectedFriendHandler)(NSString *username);

@interface TPChatRootViewController : TPBaseViewController

@property (copy, nonatomic) TPSelectedFriendHandler selectedFriendBlock;

@end
