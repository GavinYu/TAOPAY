//
//  TPTabBarViewController.m
//  TAOPAY
//
//  Created by admin on 2018/4/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTabBarViewController.h"

#import "YBaseNavigationController.h"
#import "HomepageViewController.h"
#import "TPFriendViewController.h"
#import "TPWalletViewController.h"
#import "TPChatViewController.h"
#import "TPAppConfig.h"
#import "YScanCodeViewController.h"

#import <RDVTabBarController/RDVTabBarItem.h>

@interface TPTabBarViewController () <RDVTabBarControllerDelegate>
{
    NSInteger selectedTabBarIiemTag;
}
@end

@implementation TPTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    self.delegate = self;
    [self configTabBarViewController];
}

//MARK: -- 配置tabBar
- (void)configTabBarViewController {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //首页
    UIViewController *homepageViewController=[mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HomepageViewController class])];
    
    YBaseNavigationController *homepageNavController = [[YBaseNavigationController alloc] initWithRootViewController:homepageViewController];
    
    //好友
    UIViewController *friendViewController=[mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([TPFriendViewController class])];
    
    YBaseNavigationController *friendNavController = [[YBaseNavigationController alloc] initWithRootViewController:friendViewController];
    
    //聊天
    UIViewController *chatViewController=[mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([TPChatViewController class])];
    
    YBaseNavigationController *chatNavController = [[YBaseNavigationController alloc] initWithRootViewController:chatViewController];
    
    //钱包
    UIViewController *walletViewController=[mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([TPWalletViewController class])];
    
    YBaseNavigationController *walletNavController = [[YBaseNavigationController alloc] initWithRootViewController:walletViewController];
    
    [self setViewControllers:@[homepageNavController, friendNavController, chatNavController, walletNavController]];
    
    [self configTabBarItems];
}

//MARK: -- 配置tabBar items
- (void)configTabBarItems {
    self.tabBar.frame = CGRectMake(0, 0, APPWIDTH, TPTABBARHEIGHT);
    self.tabBar.backgroundColor = [UIColor clearColor];
    //tab 背景
    UIImage *backgroundImage = [UIImage imageNamed:@"bg_tabBar"];
    self.tabBar.backgroundView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanButton setImage:[UIImage imageNamed:@"btn_scan"] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(clickScanButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:scanButton];
    
    [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tabBar);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    
    // tab 图片
    NSArray *tabBarItemImages = @[@"btn_home", @"btn_friend", @"btn_chat", @"btn_wallet"];
    
    // tab 标题
    NSArray *tabBarItemTitles = @[TPLocalizedString(@"tabbar_homepage"), TPLocalizedString(@"tabbar_friend"), TPLocalizedString(@"tabbar_chat") , TPLocalizedString(@"tabbar_wallet")];
    
    NSInteger index = 0;
    for (RDVTabBarItem *tabItem in [[self tabBar] items]) {
        tabItem.title = tabBarItemTitles[index];
        
        
        switch (index) {
            case 0:
            {
                tabItem.titlePositionAdjustment = UIOffsetMake(0, 6);
                tabItem.imagePositionAdjustment = UIOffsetMake(0, 3);
            }
                break;
                
            case 1:
            {
                tabItem.titlePositionAdjustment = UIOffsetMake(-25, 6);
                tabItem.imagePositionAdjustment = UIOffsetMake(-25, 3);
            }
                break;
                
            case 2:
            {
                tabItem.titlePositionAdjustment = UIOffsetMake(25, 6);
                tabItem.imagePositionAdjustment = UIOffsetMake(25, 3);
            }
                break;
                
            case 3:
            {
                tabItem.titlePositionAdjustment = UIOffsetMake(0, 6);
                tabItem.imagePositionAdjustment = UIOffsetMake(0, 3);
            }
                break;
                
            default:
                break;
        }
        
        NSDictionary *tabBarTitleUnselectedDic = @{NSForegroundColorAttributeName:TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1,NSFontAttributeName:[UIFont systemFontOfSize:13]};
        //修改tabberItem的title颜色
        tabItem.selectedTitleAttributes = tabBarTitleUnselectedDic;
        tabItem.unselectedTitleAttributes = tabBarTitleUnselectedDic;
        tabItem.tag = BASETAG + index;
        if (index == 0) {
            selectedTabBarIiemTag = tabItem.tag;
        }
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal", [tabBarItemImages objectAtIndex:index]]];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected", [tabBarItemImages objectAtIndex:index]]];
        //设置tabberItem的选中和未选中图片
        [tabItem setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}

//MARK: -- 扫码按钮事件
- (void)clickScanButton:(UIButton *)sender {
    UIStoryboard *mainStoryboard =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *toController = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([YScanCodeViewController class])];
    [self.navigationController pushViewController:toController animated:YES];
}

#pragma mark - 防止tabbar双击
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

- (void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    selectedTabBarIiemTag = tabBarController.selectedIndex;
//    [[NSNotificationCenter defaultCenter] postNotificationName:<#(nonnull NSNotificationName)#> object:<#(nullable id)#>]
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
