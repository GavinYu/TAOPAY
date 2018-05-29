//
//  YBaseNavigationController.m
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YBaseNavigationController.h"

#import "TPAppConfig.h"
#import "TPTabBarViewController.h"
#import "RootViewController.h"

@interface YBaseNavigationController ()

@end

@implementation YBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationRootController];
}

- (void)configNavigationRootController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TPBaseViewController *rootViewController;
    NSString *controllerIdentifier;
    NSString *token = [YUtil getUserDefaultInfo:YHTTPRequestTokenKey];
    if (!YObjectIsNil(token) && !YStringIsEmpty(token)){
        controllerIdentifier = NSStringFromClass([TPTabBarViewController class]);
    } else {
        controllerIdentifier = NSStringFromClass([RootViewController class]);
    }
    
    rootViewController = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    
    self.viewControllers = @[rootViewController];
    
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
