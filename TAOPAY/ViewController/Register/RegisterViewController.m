//
//  RegisterViewController.m
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "RegisterViewController.h"

#import "TPAppConfig.h"
#import "TPRegisterViewModel.h"
#import "TPTabBarViewController.h"
#import "LoginViewController.h"

@interface RegisterViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UIButton *getAuthCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) TPRegisterViewModel *registerViewModel;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubView];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.phoneNumberTextField becomeFirstResponder];
}

//MARK: -- lazyload
- (TPRegisterViewModel *)registerViewModel {
    if (!_registerViewModel) {
        _registerViewModel = TPRegisterViewModel.new;
    }
    
    return _registerViewModel;
}
#pragma mark 设置导航栏
- (void)addNavigationBar {
    self.navigationItem.title =  @"注册";
    self.navigationType = TPNavigationTypeBlack;
}
//MARK: -- 初始化子视图
- (void)initSubView {
    [self addNavigationBar];
    /// 添加事件
    [self.phoneNumberTextField addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.authCodeTextField addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

//MARK: -- textField的数据改变
- (void)textFieldValueDidChanged:(UITextField *)sender
{
    /// bind data
    self.registerViewModel.mobilePhone = self.phoneNumberTextField.text;
    self.registerViewModel.verifyCode = self.authCodeTextField.text;
    self.registerViewModel.password = self.passwordTextField.text;
    self.enterButton.enabled = self.registerViewModel.validRegister;
    self.getAuthCodeButton.enabled = self.registerViewModel.validAuthCode;
}
- (IBAction)clickEnterButton:(UIButton *)sender {
    /// 数据验证的在Controller中处理 否则的话 viewModel 中就引用了 view了
    /// 验证手机号码 正确的手机号码
    if (![NSString y_isValidMobile:self.phoneNumberTextField.text]){
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
        return;
    }
    /// 验证验证码 6位数字
    if (![NSString y_isPureDigitCharacters:self.authCodeTextField.text] || self.authCodeTextField.text.length != 6 ) {
        [SVProgressHUD showInfoWithStatus:@"验证码错误"];
        return;
    }
    //// 键盘掉下
    [self.view endEditing:YES];
    /// show loading
    [SVProgressHUD showWithStatus:@"注册中..."];
    @weakify(self);
    [self.registerViewModel registerSuccess:^(id json) {
        @strongify(self);
        [SVProgressHUD dismiss];
        if ([json boolValue]) {
            //重置NavigationBar的rootViewController
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TPTabBarViewController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TPTabBarViewController class])];
            self.navigationController.viewControllers = @[tabBarController];
        }
    } failure:^(NSError *error) {
    }];
}
//MARK: -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)clickGetAuthCodeButton:(UIButton *)sender {
//    self.getAuthCodeButton.enabled = NO;
    
    @weakify(self);
    [self.registerViewModel getAuthCodeSuccess:^(id json) {
        @strongify(self);
        [SVProgressHUD dismiss];
        if ([json boolValue]) {
//            self.getAuthCodeButton.enabled = YES;
            [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
        }
    } failure:^(NSError *error) {
    }];
}
//MARK: -- 密码登录按钮事件
- (IBAction)clickPwdLoginButton:(UIButton *)sender {
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginController = [mainSB instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
    [self.navigationController pushViewController:loginController animated:YES];
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
