//
//  TPPersonalHomepageTableHeaderView.h
//  TAOPAY
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TPTableHeaderViewType) {
    TPTableHeaderViewTypePersonal = 0,
    TPTableHeaderViewTypeFriendCircle
};

@class TPPersonalHomepageTableHeaderView;

@class TPUserInfoModel;

typedef void(^TPClickMenuHandler)(UIButton *sender);
typedef void(^TPClickSearchHandler)(UIButton *sender);
typedef void(^TPClickAvatarHandler)(TPPersonalHomepageTableHeaderView *sender);

@interface TPPersonalHomepageTableHeaderView : UIView

@property (copy, nonatomic) TPClickMenuHandler clickMenuBlock;
@property (copy, nonatomic) TPClickSearchHandler clickSearchBlock;
@property (copy, nonatomic) TPClickAvatarHandler clickAvatarBlock;

@property (strong, nonatomic) TPUserInfoModel *userInfoModel;

@property (assign, nonatomic) TPTableHeaderViewType tableHeaderViewType;

//MARK: -- instance view
+ (TPPersonalHomepageTableHeaderView *)instanceView;



@end
