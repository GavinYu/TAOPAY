//
//  YLocationModel.h
//  TAOPAY
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

#import <CoreLocation/CoreLocation.h>

@interface YLocationModel : YObject

// user current location
@property(nonatomic, strong) CLLocation *currentLocation;
// user current placemark
@property(nonatomic, strong) CLPlacemark *currentPlacemark;


@end
