//
//  YLocationManager.m
//  TAOPAY
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YLocationManager.h"

#import "TPAppConfig.h"
#import "YLocationModel.h"

@interface YLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLPlacemark *currentPlacemark;
@property (nonatomic, strong) CLLocationManager  *locationManager;              //定位管理

@end

@implementation YLocationManager

YSingletonM(LocationManager)

#pragma mark -定位 懒加载
-(CLLocationManager *)locationManager
{
    if ([CLLocationManager locationServicesEnabled]) {
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.distanceFilter=100;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locationManager requestWhenInUseAuthorization];
            }
        }
    }
    
    return _locationManager;
}

//MARK: -- start UpdatingHeading
- (void)startHeading {
    [self.locationManager startUpdatingHeading];
}

//MARK: -- start location
- (void)startLocation {
    [self.locationManager startUpdatingLocation];
}

//MARK: -- stop location
- (void)stopLocation {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    _currentLocation = [locations lastObject];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    @weakify(self);
    [geocoder reverseGeocodeLocation:_currentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       @strongify(self);
                       if (placemarks.count > 0) {
                           self.currentPlacemark = [placemarks firstObject];
                           
//                                                      for (CLPlacemark *place in placemarks) {
//                                                          DLog(@"name,%@",place.name);                       // 位置名
//                                                          DLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
//                                                          DLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
//                                                          DLog(@"locality,%@",place.locality);               // 市
//                                                          DLog(@"subLocality,%@",place.subLocality);         // 区
//                                                          DLog(@"country,%@",place.country);                 // 国家
//                                                      }
                       }
                       
                       [manager stopUpdatingLocation];
                       
                       
                       if (self.startLocationBlock) {
                           YLocationModel *tmpDataModel = [YLocationModel new];
                           tmpDataModel.currentLocation = self.currentLocation;
                           tmpDataModel.currentPlacemark = self.currentPlacemark;
                           
                           self.startLocationBlock(tmpDataModel);
                       }
                   }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [manager stopUpdatingLocation];
    
    if ([error code]==kCLErrorDenied) {
        DLog(@"访问被拒绝");
    } else if ([error code]==kCLErrorLocationUnknown) {
        DLog(@"无法获取位置信息");
    }
    
    if (_startLocationBlock) {
        _startLocationBlock(nil);
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            DLog(@"用户未决定");
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            DLog(@"受限制");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            if([CLLocationManager locationServicesEnabled]) {
                DLog(@"定位开启,被拒绝");
                // iOS8.0+
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"guide_tips", nil) message:NSLocalizedString(@"flight_interface_location_setting_tips", nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *allowAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"flight_interface_location_setting_allow", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                        NSURL *url = [NSURL URLWithString:@"App-Prefs:root=General&path=LOCATION_SERVICES"];
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if([[UIApplication sharedApplication] canOpenURL:url])
                        {
                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        }
                    });
                    
                }];
                UIAlertAction *notAllowAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"flight_interface_location_setting_not_allow", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    exit(0);
                }];
                [alertController addAction:notAllowAction];
                [alertController addAction:allowAction];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
                
                
                
            } else {
                DLog(@"定位服务关闭");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            DLog(@"前后台定位授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            [self.locationManager startUpdatingLocation];
            DLog(@"前台定位授权");
            break;
        }
        default:
            break;
    }
}

#pragma mark - CLLocationManagerDelegate
// 当获取到用户方向时就会调用
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    /*
     magneticHeading 设备与磁北的相对角度
     trueHeading 设置与真北的相对角度, 必须和定位一起使用, iOS需要设置的位置来计算真北
     真北始终指向地理北极点
     */
    //        NSLog(@"指南针角度：%f", newHeading.magneticHeading);
    
    // 1.将获取到的角度转为弧度 = (角度 * π) / 180;
    // 2.顺时针 正 逆时针 负数
    CGFloat angle = newHeading.magneticHeading / 180 * M_PI + M_PI_2;
    if (_startHeadingBlock) {
        _startHeadingBlock(-angle);
    }
}

@end
