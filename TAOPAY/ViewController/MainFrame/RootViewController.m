//
//  RootViewController.m
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "RootViewController.h"

#import "TPTabBarViewController.h"
#import "TPAppConfig.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationView.hidden = YES;
//    self.navigationType = TPNavigationTypeBlack;
    
}

- (void)isLogin {
    NSString *token = [YUtil getUserDefaultInfo:YHTTPRequestTokenKey];
    if (!YObjectIsNil(token) && !YStringIsEmpty(token)){
        NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:0];
        [viewControllers addObjectsFromArray:self.navigationController.viewControllers];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TPTabBarViewController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TPTabBarViewController class])];
        [viewControllers insertObject:tabBarController atIndex:0];
        [self.navigationController setViewControllers:viewControllers];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self isLogin];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
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
