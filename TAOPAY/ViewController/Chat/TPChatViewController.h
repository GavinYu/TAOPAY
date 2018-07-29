//
//  TPChatViewController.h
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//
#import "EaseMessageViewController.h"

#import "EaseEmotionManager.h"
#import "EaseEmoji.h"
#import "EaseChatToolbar+TPExtend.h"

typedef void(^TPChatToolBarAddressBookHandler)(void);

@interface TPChatViewController :  EaseMessageViewController <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>

@property (copy, nonatomic) TPChatToolBarAddressBookHandler addressBookBlock;

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;

- (void)reloadDingCellWithAckMessageId:(NSString *)aMessageId;

@end
