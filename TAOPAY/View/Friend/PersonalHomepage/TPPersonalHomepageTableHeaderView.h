//
//  TPPersonalHomepageTableHeaderView.h
//  TAOPAY
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPPersonalHomepageTableHeaderView;

typedef void(^TPClickMenuHandler)(UIButton *sender);
typedef void(^TPClickSearchHandler)(UIButton *sender);
typedef void(^TPClickAvatarHandler)(TPPersonalHomepageTableHeaderView *sender);

@interface TPPersonalHomepageTableHeaderView : UIView

@property (copy, nonatomic) TPClickMenuHandler clickMenuBlock;
@property (copy, nonatomic) TPClickSearchHandler clickSearchBlock;
@property (copy, nonatomic) TPClickAvatarHandler clickAvatarBlock;

//MARK: -- instance view
+ (TPPersonalHomepageTableHeaderView *)instanceView;



@end
