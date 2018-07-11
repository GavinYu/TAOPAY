//
//  HomepageViewController.m
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "HomepageViewController.h"

#import "TPAppConfig.h"
#import "TPHomepageViewModel.h"
#import "LoginViewController.h"
#import "YHTTPService.h"
#import "TPShoppingHomepageViewController.h"
#import "TPShopMainViewModel.h"

@interface HomepageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) TPHomepageViewModel *homeViewModel;
@property (weak, nonatomic) IBOutlet UILabel *integralTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *synButton;
@property (weak, nonatomic) IBOutlet UIButton *freeTaxButton;
@property (weak, nonatomic) IBOutlet UIButton *addressbookButton;
@property (weak, nonatomic) IBOutlet UIButton *nearShopButton;
@property (weak, nonatomic) IBOutlet UIButton *shippingButton;

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubView];
    
    if (![YHTTPService sharedInstance].currentUser.username) {
        [self requestGetUserInfo];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavigationBar];
}
//MARK: -- 设置导航栏
- (void)configNavigationBar {
    self.navigationView.title = TPLocalizedString(@"navigation_title");
    self.navigationView.isShowBackButton = NO;
    self.navigationView.isShowNavRightButtons = YES;
    [self.view addSubview:self.navigationView];
}

//MARK: -- lazyload
- (TPHomepageViewModel *)homeViewModel {
    if (!_homeViewModel) {
        _homeViewModel = TPHomepageViewModel.new;
    }
    
    return _homeViewModel;
}

//MARK: -- 初始化子视图
- (void)initSubView {
    [self loadBackgroundImageView];
    self.integralTipLabel.text = TPLocalizedString(@"homepage_integral");
    [self.synButton setTitle:TPLocalizedString(@"homepage_apply") forState:UIControlStateNormal];
    [self.shippingButton setTitle:TPLocalizedString(@"homepage_shopping") forState:UIControlStateNormal];
    [self.nearShopButton setTitle:TPLocalizedString(@"homepage_near_shop") forState:UIControlStateNormal];
    [self.addressbookButton setTitle:TPLocalizedString(@"homepage_addressbook") forState:UIControlStateNormal];
    [self.freeTaxButton setTitle:TPLocalizedString(@"homepage_free_tax") forState:UIControlStateNormal];
//    [self.view bringSubviewToFront:self.navigationView];
}

//MARK: -- 加载背景的GIF图片
- (void)loadBackgroundImageView {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bg_detour_ball@2x" ofType:@"gif"];
    UIImage *bgImage = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:filePath]];
    _bgImageView.image = bgImage;
}

- (void)requestGetUserInfo {
    @weakify(self);
    [self.homeViewModel getUserInfoSuccess:^(id json) {
        @strongify(self);
        if ([json boolValue]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateSubView];
            });
        }
    } failure:^(NSString *error) {
        [self showErrorAlertView:@"您长时间未登录，请重新登录"];
    }];
}

//MARK: -- 弹出错误提示框
- (void)showErrorAlertView:(NSString *)errorMSG {
    [UIAlertView bk_showAlertViewWithTitle:TPLocalizedString(@"wallet_tips") message:errorMSG cancelButtonTitle:nil otherButtonTitles:@[TPLocalizedString(@"wallet_sure")] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            /// 跳转
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
            [self.navigationController pushViewController:loginController animated:YES];
        }
    }];
}

//MARK: -- 更新子视图
- (void)updateSubView {
    self.integralLabel.text = [YHTTPService sharedInstance].currentUser.point;
}
//MARK: -- 申请 按钮事件
- (IBAction)clickApplyForButton:(UIButton *)sender {
    
}
//MARK: -- 精品购物 按钮事件
- (IBAction)clickBoutiqueShoppingButton:(UIButton *)sender {
    TPShopMainViewModel *shopMainViewModel = [[TPShopMainViewModel alloc] initWithParams:@{YViewModelTitleKey:TPLocalizedString(@"homepage_shopping")}];
    TPShoppingHomepageViewController *shoppingHomepageController = [[TPShoppingHomepageViewController alloc] initWithViewModel:shopMainViewModel];
    [self.navigationController pushViewController:shoppingHomepageController animated:YES];
}
- (IBAction)clickNearbyStoresButton:(UIButton *)sender {
}
- (IBAction)clickCrossTaxExemptionButton:(UIButton *)sender {
}
- (IBAction)clickAddressBookButton:(UIButton *)sender {
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
