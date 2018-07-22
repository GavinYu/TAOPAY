//
//  TPMacros.h
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#ifndef TPMacros_h
#define TPMacros_h

/*--------------------------- Add by GavinYu Start ----------------------------*/

//RGB颜色转换（16进制->10进制）
#ifndef UICOLOR_FROM_HEXRGB
#define UICOLOR_FROM_HEXRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif

#ifndef UICOLOR_FROM_HEXRGB_ALPHA
#define UICOLOR_FROM_HEXRGB_ALPHA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
#endif

//RGB颜色设置
#ifndef UICOLOR_FROM_RGB
#define UICOLOR_FROM_RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#endif

#define MainScreenBounds  [UIScreen mainScreen].bounds
// 屏幕高度
#ifndef SCREENHEIGHT
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.width > [[UIScreen mainScreen] bounds].size.height?[[UIScreen mainScreen] bounds].size.height:[[UIScreen mainScreen] bounds].size.width)
#endif

// 屏幕宽度
#ifndef SCREENWIDTH
#define SCREENWIDTH ([[UIScreen mainScreen] bounds].size.width < [[UIScreen mainScreen] bounds].size.height?[[UIScreen mainScreen] bounds].size.height:[[UIScreen mainScreen] bounds].size.width)
#endif

//屏幕宽度(正常情况下)
#define APPWIDTH [UIScreen mainScreen].bounds.size.width

//屏幕高度(正常情况下)
#define APPHEIGHT [UIScreen mainScreen].bounds.size.height

//索引基础值
#define BASETAG   100
//iphone x 判断
#define DeviceIsIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 横屏导航栏高度
#ifndef YNCNAVGATIONBARHEIGHT
#define YNCNAVGATIONBARHEIGHT 36.0
#endif

// 导航栏高度
#ifndef NAVGATIONBARHEIGHT
#define NAVGATIONBARHEIGHT (DeviceIsIPhoneX == YES ? 88 : 64)
#endif

// iPhone X 竖屏底部不安全区域部分高度
#ifndef BottomUnsafeArea
#define BottomUnsafeArea (DeviceIsIPhoneX == YES ? 34 : 0)
#endif

// iPhone X 竖屏顶部不安全区域部分高度
#ifndef TopUnsafeArea
#define TopUnsafeArea (DeviceIsIPhoneX == YES ? 44 : 0)
#endif

// iPhone X 横屏底部不安全区域部分高度
#ifndef HorizontalScreenBottomUnsafeArea
#define HorizontalScreenBottomUnsafeArea (DeviceIsIPhoneX == YES ? 14 : 0)
#endif

// 状态栏高度
#ifndef STATUSBARHEIGHT
#define STATUSBARHEIGHT  (DeviceIsIPhoneX == YES ? 44 : 20)
#endif

// 底部Tab高度
#ifndef TABBARHEIGHT
#define TABBARHEIGHT 49
#endif

#define TPTABBARHEIGHT 67

// weakSelf
#ifndef WS
#define WS(weakSelf)  __weak __typeof(self) weakSelf = self
#endif

//设置系统默认字体样式的大小
#ifndef UIFONTSYSTEM
#define UIFONTSYSTEM(fontSize) [UIFont systemFontOfSize:(CGFloat)fontSize]
#endif

//设置系统默认粗体字体样式的大小
#ifndef UIFONTBOLDSYSTEM
#define UIFONTBOLDSYSTEM(fontSize) [UIFont boldSystemFontOfSize:(CGFloat)fontSize]
#endif

//设置自定义字体样式和大小
#ifndef UIFONTCUSTOM
#define UIFONTCUSTOM(fontName,fontSize) [UIFont fontWithName:(NSString *)fontName size:fontSize]
#endif

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define DLogRect(rect)  DLog(@"%s x=%f, y=%f, w=%f, h=%f", #rect, rect.origin.x, rect.origin.y,rect.size.width, rect.size.height)
#define DLogPoint(pt) DLog(@"%s x=%f, y=%f", #pt, pt.x, pt.y)
#define DLogSize(size) DLog(@"%s w=%f, h=%f", #size, size.width, size.height)
#define ALog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#define DLog(...)
#define DLogRect(rect)
#define DLogPoint(pt)
#define DLogSize(size)
#define ALog(...)
#endif

//App当前的版本号
#ifndef APPVERSION
#define APPVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#endif

//当前系统的版本号
#ifndef SYSTEMVERSION
#define SYSTEMVERSION [[[UIDevice currentDevice] systemName] stringByAppendingString:[[UIDevice currentDevice] systemVersion]]
#endif

#ifndef ISLarge47Inch
#define ISLarge47Inch ([UIScreen mainScreen].bounds.size.height>667)//6+
#endif

//当前应用在App Store的App ID
#ifndef TP_APP_ID
#define TP_APP_ID @"1231375336"
#endif

/// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define YAdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}
//获取图片资源地址
#ifndef Y_IMAGESBUNDLE_PATH
#define Y_IMAGESBUNDLE_PATH [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"YImagesBundle" ofType:@"bundle"]]
#endif

//系统版本大于等于iOS10
#ifndef NO_BELOW_iOS10
#define NO_BELOW_iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
#endif

#define USER_PASSWORD_REGULAR   @"^([a-zA-Z0-9_]){8,21}$"
#define USER_EMAIL_FORMAT_REGULAR    @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

// 是否为空对象
#define YObjectIsNil(__object)  ((nil == __object) || [__object isKindOfClass:[NSNull class]])

// 字符串为空
#define YStringIsEmpty(__string) ((__string.length == 0) || YObjectIsNil(__string))

// 字符串不为空
#define YStringIsNotEmpty(__string)  (!YStringIsEmpty(__string))

// 数组为空
#define YArrayIsEmpty(__array) ((YObjectIsNil(__array)) || (__array.count==0))

#define kPeriod 1.0  //定时器时间 （每秒执行一次）

#define TimeoutInterval 30.0

//获取沙盒目录
// App Caches 文件夹路径
#define CachesDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
// App DocumentDirectory 文件夹路径
#define DocumentDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject]
#define Document_Download [DocumentDirectiory stringByAppendingPathComponent:@"download"]

// 系统放大倍数
#define YScale [[UIScreen mainScreen] scale]

// 设置图片
#define YImageNamed(__imageName) [UIImage imageNamed:__imageName]
//  通知中心
#define YNotificationCenter [NSNotificationCenter defaultCenter]

//// --------------------  下面是公共配置  --------------------
/// TAOPAY项目重要数据备份的文件夹名称（Documents/TAOPAYDoc）利用NSFileManager来访问
#define Y_TAOPAY_DOC_NAME  @"TAOPAYDoc"

/// TAOPAY项目轻量数据数据备份的文件夹（Library/Caches/TAOPAYCache）利用NSFileManager来访问
#define Y_TAOPAY_CACHE_NAME  @"TAOPAYCache"

/// AppDelegate
#define SharedAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

////  整个应用的主题配置（颜色+字体）MAIN 代表全局都可以修改 使用前须知
//#2b2e33
#define TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1 UICOLOR_FROM_HEXRGB(0x2b2e33)
#define TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_2 [UIColor whiteColor]

/// 整个应用的视图的背景色 BackgroundColor
#define TP_MAIN_BACKGROUNDCOLOR UICOLOR_FROM_HEXRGB(0xf5f4f9)
/// 整个应用的Cell的分割线颜色
#define TP_CELL_LINE_COLOR UICOLOR_FROM_HEXRGB(0xeaeaea)
/// 整个应用的边框颜色
#define TP_MAIN_BORDER_COLOR UICOLOR_FROM_HEXRGB(0x6fc5e3)
/// 文字颜色
/// 红色
#define TP_BG_RED_COLOR UICOLOR_FROM_HEXRGB(0xc30d23)
/// TableView HeaderView title color
#define TP_TABLE_HEADER_TITLE_COLOR UICOLOR_FROM_HEXRGB(0xa4a4a4)

/// TableView FooterView title color
#define TP_TABLE_FOOTER_TITLE_COLOR UICOLOR_FROM_HEXRGB(0x878787)

/// ---- YYWebImage Option
/// 手动设置image
#define YWebImageOptionManually (YYWebImageOptionAllowInvalidSSLCertificates|YYWebImageOptionAllowBackgroundTask|YYWebImageOptionSetImageWithFadeAnimation|YYWebImageOptionAvoidSetImage)

/// 自动设置Image
#define YWebImageOptionAutomatic (YYWebImageOptionAllowInvalidSSLCertificates|YYWebImageOptionAllowBackgroundTask|YYWebImageOptionSetImageWithFadeAnimation)

//充值最大额度
#define TPRECHARGEMAX   500.00
//可用额度
#define TPUSELIMITMAX   500.00

#define LanguageToolLocalizedString(string) NSLocalizedString((NSString *)string, nil)

#define TPLocalizedString(key)  NSLocalizedString(key, nil)

//环信SDK
#define EasyMobSDKAppKey   @"1113180712253091"

/*--------------------------- Add by GavinYu End ----------------------------*/


#endif /* TPMacros_h */
