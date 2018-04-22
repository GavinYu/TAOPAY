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

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UIButton *getAuthCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (nonatomic, strong) TPRegisterViewModel *viewModel;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubView];
}

//MARK: -- lazyload
- (TPRegisterViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = TPRegisterViewModel.new;
    }
    
    return _viewModel;
}
#pragma mark 设置导航栏
- (void)addNavigationBar {
    [self.view addSubview:self.myNavigationBar];
    [self.myNavigationBar setTitleName:@"注册" leftBtnName:@"btn_back.png" rightBtnName:nil];
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
    [self.authCodeTextField addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

//MARK: -- textField的数据改变
- (void)textFieldValueDidChanged:(UITextField *)sender
{
    /// bind data
    self.viewModel.mobilePhone = self.phoneNumberTextField.text;
    self.viewModel.verifyCode = self.authCodeTextField.text;
    self.enterButton.enabled = self.viewModel.validRegister;
    self.getAuthCodeButton.enabled = self.viewModel.validAuthCode;
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
