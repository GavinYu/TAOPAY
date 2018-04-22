//
//  LoginViewController.m
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "LoginViewController.h"

#import "TPLoginViewModel.h"
#import "TPAppConfig.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (nonatomic, strong) TPLoginViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubView];
}

//MARK: -- lazyload
- (TPLoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = TPLoginViewModel.new;
    }
    
    return _viewModel;
}

#pragma mark 设置导航栏
- (void)addNavigationBar {
    [self.view addSubview:self.myNavigationBar];
    [self.myNavigationBar setTitleName:@"登录" leftBtnName:@"btn_back.png" rightBtnName:nil];
    //导航栏左边“返回”按钮
     @weakify(self)
    [self.myNavigationBar leftBtnBlock:^(id sender){
        @strongify(self);
        [self back];
    }];
}
//MARK: -- 初始化子视图
- (void)initSubView {
    [self addNavigationBar];
    /// 添加事件
    [self.phoneNumberTextField addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
}
//MARK: -- 进入按钮事件
- (IBAction)clickLoginButton:(UIButton *)sender {
    /// 数据验证的在Controller中处理 否则的话 viewModel 中就引用了 view了
    /// 验证手机号码 正确的手机号码
    if (![NSString y_isValidMobile:self.phoneNumberTextField.text]){
        [SVProgressHUD showWithStatus:@"请输入正确的手机号码"];
        return;
    }

    //// 键盘掉下
    [self.view endEditing:YES];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:0];
    [viewControllers addObjectsFromArray:self.navigationController.viewControllers];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    [viewControllers insertObject:tabBarController atIndex:0];
    [self.navigationController setViewControllers:viewControllers];
    [self.navigationController popToRootViewControllerAnimated:YES];
   
//    @weakify(self);
//    [self.viewModel loginSuccess:^(id json) {
//        @strongify(self);
//        if ([json boolValue] == YES) {
//            NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:0];
//            [viewControllers addObjectsFromArray:self.navigationController.viewControllers];
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
//            [viewControllers insertObject:tabBarController atIndex:0];
//            [self.navigationController setViewControllers:viewControllers];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//    } failure:nil];
}

//MARK: -- textField的数据改变
- (void)textFieldValueDidChanged:(UITextField *)sender
{
    /// bind data
    self.viewModel.mobilePhone = self.phoneNumberTextField.text;
    self.viewModel.password = self.passwordTextField.text;
    self.loginButton.enabled = self.viewModel.validLogin;
    
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
