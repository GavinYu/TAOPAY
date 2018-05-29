//
//  YBaseViewController.m
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YBaseViewController.h"

#import "TPAppConfig.h"

@interface YBaseViewController ()
{
    UIButton *_leftBtn, *_rightBtn;
}

@property (strong, nonatomic) NSMutableArray *rightCustomButtonArray;
@end

@implementation YBaseViewController

//MARK: -- view lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [UIViewController attemptRotationToDeviceOrientation];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.fd_viewControllerBasedNavigationBarAppearanceEnabled = NO;
    self.fd_prefersNavigationBarHidden = YES;
    // Do any additional setup after loading the view.
//#ifdef __IPHONE_11_0
//    /// ignore adjust scroll 64
//    self.automaticallyAdjustsScrollViewInsets = YES;
//#else
//    /// ignore adjust scroll 64
//    self.automaticallyAdjustsScrollViewInsets = NO;
//#endif

    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

//MARK: -- lazyload myNavigationBar
- (YNavigationBar *)myNavigationBar {
    if (!_myNavigationBar) {
        _myNavigationBar = [[YNavigationBar alloc] initWithFrame:CGRectMake(0, 0, APPWIDTH, NAVGATIONBARHEIGHT)];
    }
    
    return _myNavigationBar;
}

#pragma mark 返回
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Status bar
- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
