//
//  TPPayWayBottomView.h
//  TAOPAY
//
//  Created by admin on 2018/7/7.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TPPayPagePayHandler)(UIButton *sender);

@interface TPPayWayBottomView : UIView

@property (copy, nonatomic) TPPayPagePayHandler payBlock;
@property (copy, nonatomic) NSString *totalMoney;

+ (TPPayWayBottomView *)instancePayWayBottomView;

@end
