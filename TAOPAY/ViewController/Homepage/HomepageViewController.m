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

@interface HomepageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) TPHomepageViewModel *homeViewModel;

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"首页";
    self.navigationType = TPNavigationTypeWhite;
    
    [self initSubView];
    
    if (![YHTTPService sharedInstance].currentUser.username) {
        [self requestGetUserInfo];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
        [self showErrorAlertView:error];
    }];
}

//MARK: -- 弹出错误提示框
- (void)showErrorAlertView:(NSString *)errorMSG {
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:errorMSG cancelButtonTitle:nil otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
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
- (IBAction)clickApplyForButton:(UIButton *)sender {
}
- (IBAction)clickBoutiqueShoppingButton:(UIButton *)sender {
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
