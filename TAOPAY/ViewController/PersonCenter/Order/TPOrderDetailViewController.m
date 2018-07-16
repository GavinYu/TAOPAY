//
//  TPOrderDetailViewController.m
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderDetailViewController.h"

#import "TPAppConfig.h"

#import "TPOrderInfoModel.h"

#import "TPOrderDetailViewModel.h"
#import "TPOrderPayViewModel.h"

#import "TPOrderGoodsCell.h"
#import "TPReceiveAddressView.h"
#import "TPOrderTableHeaderView.h"
#import "TPOrderDetailTableFooterView.h"
#import "TPOrderDetailSectionFooterView.h"

#import "TPPersonCenterViewController.h"
#import "TPPayViewController.h"

@interface TPOrderDetailViewController ()

@property (nonatomic, strong) TPOrderDetailViewModel *viewModel;
@property (nonatomic, strong) TPReceiveAddressView *myTableHeaderView;
@property (nonatomic, strong) TPOrderDetailTableFooterView *myTableFooterView;

@end

@implementation TPOrderDetailViewController
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
    self.tableView.frame = CGRectMake(0, 14, APPWIDTH, APPHEIGHT-14);
    
    [self setupTableHeaderView];
    [self setupTableFooterView];
    //tableView 注册cell 和 headerview
    [self.tableView y_registerNibCell:[TPOrderGoodsCell class]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TPOrderDetailTableFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TPOrderDetailTableFooterView class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TPReceiveAddressView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TPReceiveAddressView class])];
    
}

//MARK: -- 设置tableview FooterView
- (void)setupTableHeaderView {
    self.myTableHeaderView = [TPReceiveAddressView instanceReceiveAddressView];
    self.myTableHeaderView.isShowModifyButton = YES;
    self.tableView.tableHeaderView = self.myTableHeaderView;
    
    @weakify(self);
    [self.myTableHeaderView setModifyAddressBlock:^(TPReceiveAddressView *sender) {
        //FIXME:TODO -- 弹出修改地址的视图，暂时屏蔽调用接口
        @strongify(self);
        [self pushToModifyAddressPage];
//        [self.viewModel modifyAddress:sender.addressModel withModifyType:TPAddressModifyTypeEdit success:^(id json) {
//        } failure:^(NSString *error) {
//        }];
    }];
}

//MARK: -- 设置tableview FooterView
- (void)setupTableFooterView {
    self.myTableFooterView = [TPOrderDetailTableFooterView instanceView];
    self.tableView.tableFooterView = self.myTableFooterView;
    
    @weakify(self);
    [self.myTableFooterView setClickCpyBlock:^(UIButton *sender) {
        @strongify(self);
        //FIXME:TODO -- 复制操作

    }];
    
    [self.myTableFooterView setClickCancellBlock:^(UIButton *sender) {
        @strongify(self);
        //FIXME:TODO -- 取消订单操作，暂时还没有接口
        
    }];
    
    
    [self.myTableFooterView setClickPayBlock:^(UIButton *sender) {
        @strongify(self);
        //FIXME:TODO -- 去支付操作
        [self pushToNextController:self.viewModel.orderId];
    }];
}

//MARK: -- 跳转到订单支付页
- (void)pushToNextController:(NSString *)modelId {
    TPOrderPayViewModel *viewModel = [[TPOrderPayViewModel alloc] initWithParams:@{YViewModelIDKey:modelId, YViewModelTitleKey:@"付款"}];
    viewModel.payPrice = self.viewModel.orderInfoModel.total;
    TPPayViewController *toController = [[TPPayViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:toController animated:YES];
}

//MARK: -- 弹出地址修改页
- (void)pushToModifyAddressPage {
    
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
    [self.viewModel getOrderInfoSuccess:^(id json) {
        //FIXME: TODO --
        @strongify(self);
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.tableView reloadData];
            self.myTableHeaderView.addressModel = self.viewModel.orderInfoModel.address;
        });
    } failure:^(NSString *error) {
        @strongify(self);
        [self tableViewDidFinishTriggerHeader:YES reload:NO];
    }];
}

//MARK: - UITableViewDataSource Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    TPOrderGoodsCell *cell = [TPOrderGoodsCell cellForTableView:tableView];
    
    if (self.viewModel.dataSource.count > 0) {
        [cell displayCellByDataSources:self.viewModel.dataSource[row] rowAtIndexPath:indexPath];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 89;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //FIXME:TODO -- 因为没有真实数据，暂时屏蔽
    TPOrderTableHeaderView *hearderView = [TPOrderTableHeaderView instanceView];
    
    //    hearderView.dataDictionary = [[self.viewModel.dataSource objectAtIndex:section] firstObject];
    //    @weakify(self);
    //    hearderView.tapGestureBlock = ^(TPOrderTableHeaderView *sender) {
    //        @strongify(self);
    //        NSDictionary *dic = sender.dataDictionary;
    //        [self pushToShopGoodsListController:@"" withTitle:@""];
    //    };
    
    return hearderView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TPOrderDetailSectionFooterView *footerView = [TPOrderDetailSectionFooterView instanceView];
    if (self.viewModel.orderInfoModel) {
        footerView.orderInfoModel = self.viewModel.orderInfoModel;
    }
    
    @weakify(self);
    footerView.clickConnectBlock = ^(UIButton *sender) {
        @strongify(self);
        //FIXME:TODO -- 联系卖家
    };
    
    footerView.clickTelBlock = ^(UIButton *sender) {
        @strongify(self);
        //FIXME:TODO -- 拨打电话
        
    };
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    // 跳转到商品详请
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
