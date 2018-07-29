//
//  TPChatFriendListView.h
//  TAOPAY
//
//  Created by admin on 2018/7/28.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TPSelectedFriendHandler)(NSString *username);

@interface TPChatFriendListView : UIView

@property (copy, nonatomic) TPSelectedFriendHandler selectedFriendBlock;

+ (TPChatFriendListView *)instanceView;

@end
