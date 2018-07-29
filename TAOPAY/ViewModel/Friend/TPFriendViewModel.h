//
//  TPFriendViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/5/6.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTableViewModel.h"

@interface TPFriendViewModel : TPTableViewModel

@property (readonly, assign, nonatomic) BOOL isFinished;

- (void)requestAuthorizationForAddressBook;
// 添加好友
- (void)addFriendWithFriendId:(NSString *)friendId
                    withPhone:(NSString *)phone
                      success:(void(^)(id json))success
                      failure:(void (^)(NSString *error))failure;
@end
