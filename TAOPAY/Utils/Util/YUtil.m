//
//  YUtil.m
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YUtil.h"

#import "TPMacros.h"

@implementation YUtil
/*--------------------------- Add by GavinYu Start ----------------------------*/
#pragma mark 获取文本的高度
+ (CGFloat)getTextHeightWithContent:(nullable NSString *)content withContentSizeOfWidth:(CGFloat)contentWidth withAttribute:(nullable NSDictionary<NSString *, id> *)attribute {
    CGSize size = [content boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT)
                                        options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attribute context:nil].size;
    
    return size.height;
}

#pragma mark 获取文本的宽度
+ (CGFloat)getTextWidthWithContent:(nullable NSString *)content withContentSizeOfHeight:(CGFloat)contentHeight withAttribute:(nullable NSDictionary<NSString *, id> *)attribute {
    CGSize size = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, contentHeight)
                                        options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attribute context:nil].size;
    
    return size.width;
}

#pragma mark  邮箱合法验证
+(BOOL)isValidateEmail:(nullable NSString *)email
{
    return  [self isValidateByRegex:USER_EMAIL_FORMAT_REGULAR withInputString:email];
}

#pragma mark 获取本地UserDefault信息
+(nullable id)getUserDefaultInfo:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

#pragma mark 保存本地UserDefault信息
+(void)saveUserDefaultInfo:(nullable id)value forKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:value forKey:key];
    [userDefault synchronize];
}

#pragma mark 移除本地UserDefault信息
+(void)removeUserDefaultInfo:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:key];
    [userDefault synchronize];
}

//MARK: second change string
+ (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    CGFloat minutes = totalSeconds / 60.0;
    
    return [NSString stringWithFormat:@"%.1f", minutes];
}

//MARK: -- 图像头尾虚化
+ (UIImage *)imageHeadandTailBlur:(NSString *)imageName {
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:imageName]];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    [filter setValue:[NSNumber numberWithFloat:9.0] forKey:@"inputRadius"];
    
    CIImage *result=[filter outputImage];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return resultImage;
}

//MARK: -- 强制旋转屏幕
+ (void)orientationToPortrait:(UIInterfaceOrientation)orientation {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];//前两个参数已被target和selector占用
    [invocation invoke];
    
}

#pragma mark -
#pragma mark 字符串转换为时间
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)formatString{
    
    //@"yyyy-MM-dd HH:mm:ss zzz"，zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

#pragma mark 时间转换为字符串
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)formatString{
    //@"yyyy-MM-dd HH:mm:ss zzz"，zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

//MARK: -- 根据GPS计算两个点的距离
+ (CGFloat)calculateDistanceSourceLocationCoordinate2D:(CLLocationCoordinate2D)origCoordinate  WithDistLocationCoordinate2D:(CLLocationCoordinate2D)distCoordinate {
    CLLocationDistance distance = 0;
    
    CLLocation *orig = [[CLLocation alloc] initWithLatitude:origCoordinate.latitude longitude:origCoordinate.longitude];
    CLLocation* dist = [[CLLocation alloc] initWithLatitude:distCoordinate.latitude longitude:distCoordinate.longitude];
    
    distance = [orig distanceFromLocation:dist];
    //    DLog(@"距离:%.1f M",distance);
    
    return  distance;
}

//MARK: -- 单位转换（米->英尺）
+ (CGFloat)meterTransformToFeet:(CGFloat)meter {
    return meter * 3.2808399;
}

//MARK: -- 单位转换（千米/小时->英里/小时）
+ (CGFloat)kmPerHourTransformToMilesPerHour:(CGFloat)kmPH {
    return kmPH/1.6;
}
#pragma mark -
#pragma mark 获取资源图片
// 加载JPG图片
+(UIImage *)imagJPGPathName:(NSString *)name
{
    if (ISLarge47Inch) {
        [name stringByAppendingString:@"@3x"];
    } else {
        [name stringByAppendingString:@"@2x"];
    }
    
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"jpg"]];
}
// 加载PNG图片
+(UIImage *)imagPNGPathName:(NSString *)name
{
    if (ISLarge47Inch) {
        name = [name stringByAppendingString:@"@3x"];
    } else {
        name = [name stringByAppendingString:@"@2x"];
    }
    
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]];
}

//MARK: -- 匹配正则表达式
+ (BOOL)isValidateByRegex:(NSString *)regex withInputString:(NSString *)inputString {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:inputString];
}
//MARK: -- 根据系统语言转换成传给后台的语言对应的字符串
+ (NSString *)getAppLanguage {
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language hasPrefix:@"zh-Hans"]) {
        return @"cn";
    } else {
        return @"ko";
    }
}

/*--------------------------- Add by GavinYu End ----------------------------*/
@end
