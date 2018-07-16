//
//  TPPayViewController.m
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPPayViewController.h"

#import "TPAppConfig.h"

#import "TPOrderPayViewModel.h"

#import "TPWalletCommonCell.h"
#import "TPOrderPayTableFooterView.h"

#import "TPUPPayManager.h"

#import "TPPersonCenterViewController.h"

@interface TPPayViewController ()
@property (nonatomic, strong) TPOrderPayTableFooterView *myTableFooterView;
@property (strong, nonatomic) TPOrderPayViewModel *viewModel;

@end

@implementation TPPayViewController
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationBar];
    [self setupSubViews];
    [self bindViewModel];
}

//MARK: -- config NavigationBar
- (void)configNavigationBar {
    self.navigationView.title = self.viewModel.title;
    self.navigationView.isShowBackButton = YES;
    self.navigationView.isShowNavRightButtons = YES;
    self.navigationView.isShowDownArrowImage = NO;
    [self.view addSubview:self.navigationView];
    
    @weakify(self);
    self.navigationView.clickMeHandler = ^(UIButton *sender) {
        @strongify(self);
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            if ([obj isKindOfClass:[TPPersonCenterViewController class]]) {
                *stop = YES;
                
                [self.navigationController popToViewController:obj animated:YES];
            }
        }];
    };
    
    self.navigationView.clickHomeHandler = ^(UIButton *sender) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
}

//MARK: -- 初始化子控件
- (void)setupSubViews {
    self.tableView.frame = CGRectMake(0, 0, APPWIDTH, APPHEIGHT);
    
    [self setupTableFooterView];
    
    //tableView 注册cell 和 headerview
    [self.tableView y_registerNibCell:[TPWalletCommonCell class]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TPOrderPayTableFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TPOrderPayTableFooterView class])];
    
}
//MARK: -- 设置tableview FooterView
- (void)setupTableFooterView {
    self.myTableFooterView = [TPOrderPayTableFooterView instanceView];
    self.myTableFooterView.totalPrice = self.viewModel.payPrice;
    
    @weakify(self);
    [self.myTableFooterView setClickAllBlock:^(TPOrderPayTableFooterView *sender) {
        //FIXME:TODO: 需要获取到卡的全部余额
        @strongify(self);
        
    }];
    
    [self.myTableFooterView setClickPayBlock:^(TPOrderPayTableFooterView *sender) {
        //FIXME:TODO:--- 需要订单ID
        @strongify(self);
        [self.viewModel getOrderTnSuccess:^(id json) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                
                [[TPUPPayManager sharedUPPayManager] startPay:self.viewModel.tn viewController:self completeBlock:^(BOOL result) {
                }];
            });
        } failure:^(NSString *error) {
        }];
    }];
    
    self.tableView.tableFooterView = self.myTableFooterView;
}

//MARK: -- 跳转到支付设置页
- (void)pushToNextController:(NSString *)modeId {
//    TPOrderDetailViewModel *viewModel = [[TPOrderDetailViewModel alloc] initWithParams:@{YViewModelIDKey:modeId, YViewModelTitleKey:@"我的订单"}];
//    TPOrderDetailViewController *toController = [[TPOrderDetailViewController alloc] initWithViewModel:viewModel];
//    [self.navigationController pushViewController:toController animated:YES];
}

#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
    
}

//MARK: - UITableViewDataSource Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    TPWalletCommonCell *cell = [TPWalletCommonCell cellForTableView:tableView];
    
    if (self.viewModel.dataSource.count > 0) {
        [cell displayCellByDataSources:self.viewModel.dataSource[row] rowAtIndexPath:indexPath];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 7;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *hearderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPWIDTH, 18)];
    hearderView.backgroundColor = UICOLOR_FROM_HEXRGB(0xe1e0e4);

    return hearderView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPWIDTH, 7)];
    footerView.backgroundColor = UICOLOR_FROM_HEXRGB(0xe1e0e4);
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger row = indexPath.row;
    NSDictionary *item = self.viewModel.dataSource[row];
    //FIXME:TODO -- 需要跳转到支付设置
//    [self pushToNextController:item[@"orderId"]];
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
