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
#import "TPTabBarViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (nonatomic, strong) TPLoginViewModel *loginViewModel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *acountLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *findPwdButton;
@property (weak, nonatomic) IBOutlet UILabel *loginTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *serviceProtocolButton;
@property (weak, nonatomic) IBOutlet UILabel *applyLabel;
@property (weak, nonatomic) IBOutlet UIButton *freeButton;

@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.phoneNumberTextField becomeFirstResponder];
    
}

//MARK: -- lazyload viewModel
- (TPLoginViewModel *)loginViewModel {
    if (!_loginViewModel) {
        _loginViewModel = TPLoginViewModel.new;
    }
    
    return _loginViewModel;
}

#pragma mark 设置导航栏
- (void)addNavigationBar {
    self.navigationView.title = TPLocalizedString(@"person_center_login");
    self.navigationView.navigationType = TPNavigationTypeBlack;
    self.navigationView.isShowBackButton = YES;
    self.navigationView.isShowNavRightButtons = NO;
    self.navigationView.isShowDownArrowImage = NO;
    
    [self.view addSubview:self.navigationView];
}
//MARK: -- 初始化子视图
- (void)initSubView {
    [self addNavigationBar];
    
    self.acountLabel.text = TPLocalizedString(@"person_center_phone");
    self.phoneNumberTextField.placeholder = TPLocalizedString(@"person_center_input_phone");
    self.passwordLabel.text = TPLocalizedString(@"person_center_password");
    self.passwordTextField.placeholder = TPLocalizedString(@"person_center_input_password");
    [self.findPwdButton setTitle:TPLocalizedString(@"person_center_find_password") forState:UIControlStateNormal];
    [self.loginButton setTitle:TPLocalizedString(@"person_center_login") forState:UIControlStateNormal];
    self.loginTipLabel.text = TPLocalizedString(@"person_center_login_tips");
    [self.serviceProtocolButton setTitle:TPLocalizedString(@"person_center_user_protocol_login") forState:UIControlStateNormal];
    self.applyLabel.text = TPLocalizedString(@"person_center_free_apply");
    [self.freeButton setTitle:TPLocalizedString(@"person_center_free_register_message") forState:UIControlStateNormal];
    
    /// 添加事件
    [self.phoneNumberTextField addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
}
//MARK: -- 进入按钮事件
- (IBAction)clickLoginButton:(UIButton *)sender {
    /// 数据验证的在Controller中处理 否则的话 viewModel 中就引用了 view了
    /// 验证手机号码 正确的手机号码
    if (![NSString y_isValidMobile:self.phoneNumberTextField.text]){
        [SVProgressHUD showWithStatus:TPLocalizedString(@"person_center_phone_format_wrong")];
        return;
    }

    //// 键盘掉下
    [self.view endEditing:YES];
    
    @weakify(self);
    [self.loginViewModel loginSuccess:^(id json) {
        @strongify(self);
        if ([json boolValue] == YES) {
            if ([self.navigationController.viewControllers.firstObject isKindOfClass:[TPTabBarViewController class]]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                //重置NavigationBar的rootViewController
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                TPTabBarViewController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TPTabBarViewController class])];
                self.navigationController.viewControllers = @[tabBarController];
            }
            
        }
    } failure:^(NSError *error) {
    }];
}

//MARK: -- textField的数据改变
- (void)textFieldValueDidChanged:(UITextField *)sender
{
    /// bind data
    self.loginViewModel.mobilePhone = self.phoneNumberTextField.text;
    self.loginViewModel.password = self.passwordTextField.text;
    self.loginButton.enabled = self.loginViewModel.validLogin;
    
}

//MARK: -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
//MARK: -- 免费注册按钮事件
- (IBAction)clickFreeRegisterButton:(UIButton *)sender {
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterViewController *registerController = [mainSB instantiateViewControllerWithIdentifier:NSStringFromClass([RegisterViewController class])];
    [self.navigationController pushViewController:registerController animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"Dealloc--%@", NSStringFromClass([self class]));
    
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
