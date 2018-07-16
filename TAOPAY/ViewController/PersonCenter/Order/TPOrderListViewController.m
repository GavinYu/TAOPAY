//
//  TPOrderListViewController.m
//  TAOPAY
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderListViewController.h"

#import "TPAppConfig.h"

#import "TPOrderModel.h"
#import "TPOrderGoodsModel.h"
#import "TPCompanyModel.h"
#import "TPOrderListModel.h"

#import "TPOrderListViewModel.h"
#import "TPOrderDetailViewModel.h"
#import "TPShopGoodsListViewModel.h"
#import "TPOrderPayViewModel.h"

#import "TPOrderGoodsCell.h"
#import "TPOrderCompanyCell.h"
#import "TPOrderTableFooterView.h"

#import "TPOrderDetailViewController.h"
#import "TPGoodsListViewController.h"
#import "TPPayViewController.h"

#import "TPPersonCenterViewController.h"

@interface TPOrderListViewController ()

@property (nonatomic, strong) TPOrderListViewModel *viewModel;

@end

@implementation TPOrderListViewController
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
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    self.navigationView.clickHomeHandler = ^(UIButton *sender) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
}

//MARK: -- 初始化子控件
- (void)setupSubViews {
    self.tableView.frame = CGRectMake(0, 0, APPWIDTH, APPHEIGHT);
    //tableView 注册cell 和 headerview
    [self.tableView y_registerNibCell:[TPOrderGoodsCell class]];
    [self.tableView y_registerNibCell:[TPOrderCompanyCell class]];
}

//MARK: -- 跳转到订单详情页
- (void)pushToNextController:(NSString *)modeId {
    TPOrderDetailViewModel *viewModel = [[TPOrderDetailViewModel alloc] initWithParams:@{YViewModelIDKey:modeId, YViewModelTitleKey:@"订单详情"}];
    TPOrderDetailViewController *toController = [[TPOrderDetailViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:toController animated:YES];
}

//MARK: -- 跳转到商家的商品列表页
- (void)pushToShopGoodsListController:(NSString *)modeId withTitle:(NSString *)title {
    TPShopGoodsListViewModel *viewModel = [[TPShopGoodsListViewModel alloc] initWithParams:@{YViewModelIDKey:modeId, YViewModelTitleKey:title}];
    TPGoodsListViewController *toController = [[TPGoodsListViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:toController animated:YES];
}

//MARK: -- 跳转到订单支付页
- (void)pushToPayController:(NSString *)modelId withPayTotalPrice:(NSString *)price {
    TPOrderPayViewModel *viewModel = [[TPOrderPayViewModel alloc] initWithParams:@{YViewModelIDKey:modelId, YViewModelTitleKey:@"付款"}];
    viewModel.payPrice = price;
    TPPayViewController *toController = [[TPPayViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:toController animated:YES];
}

#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
    
}
//MARK: -- 请求网络数据
#pragma mark - Override
//MARK: -- 下拉刷新
- (void)tableViewDidTriggerHeaderRefresh {
    /// 先调用父类的加载数据
    [super tableViewDidTriggerHeaderRefresh];
    /// 加载banners data
    @weakify(self);
    [self.viewModel getOrderListSuccess:^(id json) {
        //TODO: --
        @strongify(self);
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.tableView reloadData];
        });
    } failure:^(NSString *error) {
        @strongify(self);
        [self tableViewDidFinishTriggerHeader:YES reload:NO];
    }];
}

//MARK: - UITableViewDataSource Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (self.viewModel.dataSource.count > 0) {
        id tmpModel = self.viewModel.dataSource[section][row];
        
        if ([tmpModel isKindOfClass:[TPCompanyModel class]]) {
            TPOrderCompanyCell *cell = [TPOrderCompanyCell cellForTableView:tableView];
            [cell displayCellByDataSources:self.viewModel.dataSource[section][row] rowAtIndexPath:indexPath];
            
            TPOrderModel *sectionOrderModel = self.viewModel.orderListModel.list[section];
            cell.orderStatus = sectionOrderModel.status;
            
            return cell;
        } else {
            TPOrderGoodsCell *cell = [TPOrderGoodsCell cellForTableView:tableView];
            [cell displayCellByDataSources:self.viewModel.dataSource[section][row] rowAtIndexPath:indexPath];
            
            return cell;
        }
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (self.viewModel.dataSource.count > 0) {
        id tmpModel = self.viewModel.dataSource[section][row];
        
        if ([tmpModel isKindOfClass:[TPCompanyModel class]]) {
            return 47;
        } else {
            return 80;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TPOrderTableFooterView *footerView = [TPOrderTableFooterView instanceView];
    footerView.orderModel = self.viewModel.orderListModel.list[section];
    
    @weakify(self);
    //    footerView.clickCancellBlock = ^(TPOrderTableFooterView *sender) {
    //        @strongify(self);
    //        //FIXME:TODO -- 因为还没取消订单的接口
    //    };
    
    footerView.clickPayBlock = ^(TPOrderTableFooterView *sender) {
        @strongify(self);
        [self pushToPayController:sender.orderId withPayTotalPrice:sender.price];
    };
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    
    id tmpModel = self.viewModel.dataSource[section][row];
    
    if ([tmpModel isKindOfClass:[TPCompanyModel class]]) {
        TPCompanyModel *companyModel = (TPCompanyModel *)tmpModel;
        [self pushToShopGoodsListController:companyModel.companyId withTitle:companyModel.name];
    } else {
        //FIXME:暂时只支持跳转到订单详情，后续需要跳转到商品详情
        TPOrderModel *item = self.viewModel.orderListModel.list[section];
        
        [self pushToNextController:item.orderId];
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
