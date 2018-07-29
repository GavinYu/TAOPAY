//
//  TPPublishFriendCircleViewController.h
//  TAOPAY
//
//  Created by admin on 2018/7/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPBaseViewController.h"

@class TPUserInfoModel;

typedef void(^TPPublishFriendCircleCompletionHandler)(BOOL result);

@interface TPPublishFriendCircleViewController : TPBaseViewController

@property (copy, nonatomic) TPPublishFriendCircleCompletionHandler publishFriendCircleCompletionBlock;

@property (strong, nonatomic) TPUserInfoModel *currentUserInfoModel;

@end
