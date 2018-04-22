//
//  YBaseViewController.h
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YNavigationBar.h"

@interface YBaseViewController : UIViewController

@property (nonatomic, strong) YNavigationBar *myNavigationBar;

/** 返回前一个页面 */
-(void) back;
@end
