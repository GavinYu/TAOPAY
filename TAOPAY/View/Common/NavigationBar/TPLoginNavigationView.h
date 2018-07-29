//
//  TPLoginNavigationView.h
//  TAOPAY
//
//  Created by admin on 2018/4/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TPConstEnum.h"

typedef void(^TPClickMeButtonHandler)(UIButton *sender);
typedef void(^TPClickHomeButtonHandler)(UIButton *sender);
typedef void(^TPClickBackButtonHandler)(UIButton *sender);



@interface TPLoginNavigationView : UIView

@property (nonatomic, copy) TPClickMeButtonHandler clickMeHandler;
@property (nonatomic, copy) TPClickHomeButtonHandler clickHomeHandler;
@property (nonatomic, copy) TPClickBackButtonHandler clickBackHandler;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isShowBackButton;
@property (nonatomic, assign) TPNavigationType navigationType;
@property (nonatomic, assign) BOOL isShowNavRightButtons;
@property (nonatomic, assign) BOOL isShowDownArrowImage;

@property (copy, nonatomic) NSString *updateMeImageName;
@property (nonatomic, assign) BOOL isHiddenSearchButton;
@property (nonatomic, assign) BOOL isHiddenHomepageButton;


+ (TPLoginNavigationView *)instanceLoginNavigationView;

@end
