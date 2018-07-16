//
//  TPAreaListTableHeaderView.h
//  TAOPAY
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPAreaModel;

typedef void(^TPClickCancelButtonHandle)(UIButton *sender);
typedef void(^TPSliderViewClickEventHandle)(TPAreaModel *areaModel);

@interface TPAreaListTableHeaderView : UIView

@property (nonatomic, copy) TPClickCancelButtonHandle cancelBlock;
@property (nonatomic, copy) TPSliderViewClickEventHandle sliderClickEventBlock;

@property (strong, nonatomic) TPAreaModel *selectedAreaModel;

@property (strong, nonatomic) NSMutableArray *dataArray;

+ (TPAreaListTableHeaderView *)instanceAreaListTableHeaderView;

@end
