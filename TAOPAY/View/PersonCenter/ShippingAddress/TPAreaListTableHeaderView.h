//
//  TPAreaListTableHeaderView.h
//  TAOPAY
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^TPClickCancelButtonHandle)(UIButton *sender);

@interface TPAreaListTableHeaderView : UIView

@property (nonatomic, copy) TPClickCancelButtonHandle cancelBlock;

+ (TPAreaListTableHeaderView *)instanceAreaListTableHeaderView;

@end
