//
//  YLocationManager.h
//  TAOPAY
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "YSingleton.h"

@class YLocationModel;

typedef void(^YStartLocationCompletion)(YLocationModel * _Nullable locationDataModel);
typedef void(^YStartHeadingCompletion)(CGFloat angle);

NS_ASSUME_NONNULL_BEGIN

@interface YLocationManager : NSObject

@property (copy, nonatomic) YStartLocationCompletion startLocationBlock;
@property (copy, nonatomic) YStartHeadingCompletion startHeadingBlock;

YSingletonH(LocationManager)

//start location
- (void)startLocation;
//stop location
- (void)stopLocation;
// start UpdatingHeading
- (void)startHeading;

@end

NS_ASSUME_NONNULL_END
