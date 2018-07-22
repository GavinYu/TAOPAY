//
//  TPFriendModel.h
//  TAOPAY
//
//  Created by admin on 2018/5/6.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@interface TPFriendModel : YObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *time;

@end
