//
//  TPMenuView.h
//  TAOPAY
//
//  Created by admin on 2018/7/18.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TPMenuEventType) {
    TPMenuEventTypeMoment = 101,
    TPMenuEventTypeMine,
    TPMenuEventTypeSetting
};

typedef void(^TPClickMenuEventHandler)(UIButton *sender);

@interface TPMenuView : UIView

@property (copy, nonatomic) TPClickMenuEventHandler clickMenuEventBlock;

//MARK: -- instance view
+ (TPMenuView *)instanceView;

@end
