//
//  YSliderView.h
//  TAOPAY
//
//  Created by admin on 2018/7/8.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TPClickSliderButtonHandler)(UIButton *sender);

@interface YSliderView : UIView

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) UIFont *titleFont;

@property (copy, nonatomic) TPClickSliderButtonHandler clickSliderBlock;

+ (YSliderView *)instanceSliderView;

- (void)reloadSliderView;

@end
