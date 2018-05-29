//
//  TPBaseViewController.m
//  TAOPAY
//
//  Created by admin on 2018/4/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPBaseViewController.h"

#import "TPAppConfig.h"

@interface TPBaseViewController ()

@property (strong, nonatomic)  UIImageView *logoImageView;
@property (strong, nonatomic)  UIButton *backButton;
@property (strong, nonatomic)  UIButton *personCenterButton;
@property (strong, nonatomic)  UIButton *homepageButton;

@end

@implementation TPBaseViewController

//- (instancetype)initWithViewModel:(TPViewModel *)viewModel {
//    self = [super init];
//    if (self) {
//        self.viewModel = viewModel;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TP_MAIN_BACKGROUNDCOLOR;

    //设置导航栏
    [self configMyNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = NO;
}

//MARK: -- 设置导航栏
- (void)setupNavigationBar {
    self.navigationView = [TPLoginNavigationView instanceLoginNavigationView];
    self.navigationView.navigationType = TPNavigationTypeBlack;
    [self.view addSubview:self.navigationView];
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(APPWIDTH, NAVGATIONBARHEIGHT));
    }];
    
    @weakify(self);
    [self.navigationView setClickBackHandler:^(UIButton *sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

//MARK: -- 初始化导航栏
- (void)configMyNavigationBar {
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationController.navigationBar.translucent = NO;//设置导航栏透明度 NO表示不透明
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(20, 0, 26, 44);
    [self.backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    self.logoImageView = UIImageView.new;
    [self.navigationController.view addSubview:self.logoImageView];
    
    self.homepageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.homepageButton.frame = CGRectMake(APPWIDTH-45, 7, 30, 30);
    [self.homepageButton setImage:[UIImage imageNamed:@"icon_loginNavbar_home"] forState:UIControlStateNormal];
    [self.homepageButton addTarget:self action:@selector(clickHomeButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightHomeItem = [[UIBarButtonItem alloc] initWithCustomView:self.homepageButton];
    
    self.personCenterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.personCenterButton.frame = CGRectMake(CGRectGetMinX(self.homepageButton.frame)-40, 7, 30, 34);
    [self.personCenterButton setImage:[UIImage imageNamed:@"icon_loginNavbar_me"] forState:UIControlStateNormal];
    [self.personCenterButton addTarget:self action:@selector(clickPersonButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightPersonItem = [[UIBarButtonItem alloc] initWithCustomView:self.personCenterButton];
    
    self.navigationItem.rightBarButtonItems = @[rightHomeItem,rightPersonItem];

}
//MARK: -- 返回按钮事件
- (void)clickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK: -- Home按钮事件
- (void)clickHomeButton:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//MARK: -- 个人中心按钮事件
- (void)clickPersonButton:(UIButton *)sender {
   
}

- (void)setNavigationType:(TPNavigationType)navigationType {
    if (navigationType == TPNavigationTypeBlack) {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        [self.backButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        //改变导航栏的背景颜色，注意使用.backgroundColor去设置背景颜色，只会有淡淡的一层，跟没效果一样
        self.navigationController.navigationBar.barTintColor = TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1;
        self.logoImageView.hidden = YES;
        self.homepageButton.hidden = YES;
        self.personCenterButton.hidden = YES;
    } else {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1};
        [self.backButton setImage:[UIImage imageNamed:@"icon_loginNavbar_back"] forState:UIControlStateNormal];
        self.navigationController.navigationBar.barTintColor = TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_2;
        self.logoImageView.hidden = NO;
        self.homepageButton.hidden = NO;
        self.personCenterButton.hidden = NO;
    }
}

- (void)setIsShowBackButton:(BOOL)isShowBackButton {
    _isShowBackButton = isShowBackButton;
    
    self.backButton.hidden = !_isShowBackButton;
    if (isShowBackButton) {
        [self.logoImageView setImage:[UIImage imageNamed:@"icon_loginNavbar_detail_logo"]];
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backButton.mas_right).offset(10);
            make.centerY.equalTo(self.backButton);
            make.size.mas_equalTo(CGSizeMake(51, 10));
        }];
    } else {
        [self.logoImageView setImage:[UIImage imageNamed:@"icon_loginNavbar_logo"]];
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(31);
            make.size.mas_equalTo(CGSizeMake(80, 23));
        }];
    }
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
