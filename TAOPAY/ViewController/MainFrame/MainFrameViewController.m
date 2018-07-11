//
//  MainFrameViewController.m
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "MainFrameViewController.h"

//#import "RootViewController.h"
#import "TPTabBarViewController.h"
#import "TPAppConfig.h"
#import "YBaseNavigationController.h"

@interface MainFrameViewController ()

@end

@implementation MainFrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationRootController];
}

- (void)configNavigationRootController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *rootViewController;
    NSString *controllerIdentifier;
    NSString *token = [YUtil getUserDefaultInfo:YHTTPRequestTokenKey];
    if (!YObjectIsNil(token) && !YStringIsEmpty(token)){
        controllerIdentifier = NSStringFromClass([TPTabBarViewController class]);
    } else {
        controllerIdentifier = NSStringFromClass([YBaseNavigationController class]);
    }
    
    rootViewController = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    
    [self addChildViewController:rootViewController];
    [self.view addSubview:rootViewController.view];
//    self.navigationController.viewControllers = @[rootViewController];
    
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
