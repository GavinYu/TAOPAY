//
//  TPChatNavigationBarView.h
//  TAOPAY
//
//  Created by admin on 2018/7/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TPClickNavMeButtonHandler)(UIButton *sender);
typedef void(^TPClickNavBackButtonHandler)(UIButton *sender);

@interface TPChatNavigationBarView : UIView

@property (nonatomic, copy) TPClickNavMeButtonHandler clickMeHandler;
@property (nonatomic, copy) TPClickNavBackButtonHandler clickBackHandler;

@property (nonatomic, copy) NSString *title;

+ (TPChatNavigationBarView *)instanceView;

@end
