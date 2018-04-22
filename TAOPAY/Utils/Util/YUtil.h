//
//  YUtil.h
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface YUtil : NSObject
/*--------------------------- Add by GavinYu Start ----------------------------*/
#pragma mark 获取文本的高度
+ (CGFloat)getTextHeightWithContent:(nullable NSString *)content withContentSizeOfWidth:(CGFloat)contentWidth withAttribute:(nullable NSDictionary<NSString *, id> *)attribute;
#pragma mark 获取文本的宽度
+ (CGFloat)getTextWidthWithContent:(nullable NSString *)content withContentSizeOfHeight:(CGFloat)contentHeight withAttribute:(nullable NSDictionary<NSString *, id> *)attribute;
#pragma mark  邮箱合法验证
+ (BOOL)isValidateEmail:(nullable NSString *)email;
#pragma mark 获取本地UserDefault信息
+(nullable id)getUserDefaultInfo:(NSString *)key;
#pragma mark 保存本地UserDefault信息
+(void)saveUserDefaultInfo:(nullable id)value forKey:(NSString *)key;
#pragma mark 移除本地UserDefault信息
+(void)removeUserDefaultInfo:(NSString *)key;
//MARK: second change string
+ (NSString *)timeFormatted:(NSInteger)totalSeconds;
//图像头尾虚化
+ (UIImage *)imageHeadandTailBlur:(NSString *)imageName;
//MARK: -- 强制旋转屏幕
+ (void)orientationToPortrait:(UIInterfaceOrientation)orientation;
#pragma mark 字符串转换为时间
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)formatString;
#pragma mark 时间转换为字符串
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)formatString;
//MARK: -- 根据GPS计算两个点的距离
+ (CGFloat)calculateDistanceSourceLocationCoordinate2D:(CLLocationCoordinate2D)origCoordinate  WithDistLocationCoordinate2D:(CLLocationCoordinate2D)distCoordinate;
//MARK: -- 单位转换（米->英尺）
+ (CGFloat)meterTransformToFeet:(CGFloat)meter;
//MARK: -- 单位转换（千米/小时->英里/小时）
+ (CGFloat)kmPerHourTransformToMilesPerHour:(CGFloat)kmPH;
#pragma mark -
#pragma mark 获取资源图片
+(UIImage *)imagJPGPathName:(NSString *)name;
+(UIImage *)imagPNGPathName:(NSString *)name;
/*--------------------------- Add by GavinYu End ----------------------------*/
@end
