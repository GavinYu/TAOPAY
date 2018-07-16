//
//  TPChatViewController.m
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPChatViewController.h"

#import "TPAppConfig.h"

#import "TPPersonCenterViewController.h"

@interface TPChatViewController ()

@end

@implementation TPChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationType = TPNavigationTypeWhite;
    self.navigationItem.title = @"聊天";
    self.isShowBackButton = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    
    [self configNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
    [super viewWillDisappear:animated];
}

//MARK: -- 设置导航栏
- (void)configNavigationBar {
    self.navigationView.title = TPLocalizedString(@"navigation_title");
    self.navigationView.isShowBackButton = NO;
    self.navigationView.isShowNavRightButtons = YES;
    [self.view addSubview:self.navigationView];
    
    @weakify(self);
    self.navigationView.clickMeHandler = ^(UIButton *sender) {
        @strongify(self);
        UIStoryboard *toStoryboard = [UIStoryboard storyboardWithName:@"PersonCenter" bundle:nil];
        UIViewController *toController=[toStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([TPPersonCenterViewController class])];
        [self.navigationController pushViewController:toController animated:YES];
    };
    
    self.navigationView.clickHomeHandler = ^(UIButton *sender) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
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
