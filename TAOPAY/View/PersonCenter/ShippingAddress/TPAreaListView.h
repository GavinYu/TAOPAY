//
//  TPAreaListView.h
//  TAOPAY
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPAreaModel;

typedef void(^TPAreaSelectHandler)(TPAreaModel *selectedArea);

@interface TPAreaListView : UIView

@property (copy, nonatomic) NSString *selectAreaId;
@property (copy, nonatomic) TPAreaSelectHandler selectedAreaBlock;

//MARK: -- instance AddNewAddressView
+ (TPAreaListView *)instanceAreaListView;
- (void)show;
- (void)close;
//获取区接口
- (void)getAreaListSuccess:(void(^)(id json))success
                   failure:(void (^)(NSString *error))failure;

@end
