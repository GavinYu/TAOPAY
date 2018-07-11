//
//  TPShoppingPayViewController.m
//  TAOPAY
//
//  Created by admin on 2018/7/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShoppingPayViewController.h"

#import "TPAppConfig.h"

#import "TPReceiveAddressView.h"
#import "TPShoppingPayGoodsCell.h"
#import "TPPayWayCell.h"

#import "TPAddressListViewModel.h"
#import "TPShoppingCartViewModel.h"

#import "TPShippingAddressListViewController.h"

@interface TPShoppingPayViewController ()

@property (nonatomic, strong) TPShoppingCartViewModel *viewModel;
@property (strong, nonatomic) NSIndexPath *lastSelectedIndexPath;
@property (nonatomic, strong) TPReceiveAddressView *myTableHeaderView;

@end

@implementation TPShoppingPayViewController
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
}
//MARK: -- config NavigationBar
- (void)configNavigationBar {
    self.navigationView.title = self.viewModel.title;
    self.navigationView.isShowBackButton = YES;
    self.navigationView.isShowNavRightButtons = YES;
    self.navigationView.isShowDownArrowImage = YES;
    [self.view addSubview:self.navigationView];
}

//MARK: -- 初始化子控件
- (void)setupSubViews {
    self.tableView.frame = CGRectMake(0, NAVGATIONBARHEIGHT, APPWIDTH, APPHEIGHT-NAVGATIONBARHEIGHT);
    self.myTableHeaderView = [TPReceiveAddressView instanceReceiveAddressView];
    @weakify(self);
    self.myTableHeaderView.tapBlock = ^(UIButton *sender) {
        @strongify(self);
        [self pushToAddressListViewController];
    };
    self.tableView.tableHeaderView = self.myTableHeaderView;
    
    //tableView 注册cell 和 headerview
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TPReceiveAddressView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TPReceiveAddressView class])];
    [self.tableView y_registerNibCell:[TPPayWayCell class]];
    [self.tableView y_registerNibCell:[TPShoppingPayGoodsCell class]];
}

#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
    
    @weakify(self);
    [_KVOController y_observe:self.viewModel keyPath:@"selectAddressModel" block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
       id tmp = change[NSKeyValueChangeNewKey];
        if (tmp) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                //FIXME:TODO -- 更新选择的地址
            });
        }
        
    }];
}
//MARK: -- 请求网络数据
#pragma mark - Override
//MARK: -- 下拉刷新
- (void)tableViewDidTriggerHeaderRefresh {
    /// 先调用父类的加载数据
    [super tableViewDidTriggerHeaderRefresh];
    /// 加载banners data
    @weakify(self);
    [self.viewModel getShoppingCartListSuccess:^(id json) {
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

//MARK: -- 文本内容区域
- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}


#pragma mark - Override
//MARK: - UITableViewDataSource Methods
/// config  cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        TPShoppingPayGoodsCell *goodsCell = [TPShoppingPayGoodsCell cellForTableView:tableView];
        [goodsCell displayCellByDataSources:self.viewModel.dataSource[section][row] rowAtIndexPath:indexPath];
        
        return goodsCell;
    } else {
        TPPayWayCell *payWayCell = [TPPayWayCell cellForTableView:tableView];
        [payWayCell displayCellByDataSources:self.viewModel.dataSource[section][row] rowAtIndexPath:indexPath];
        
        if (row == 0) {
            payWayCell.isSelect = YES;
            _lastSelectedIndexPath = indexPath;
        }
        
        return payWayCell;
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        return 105;
    } else {
        return 47;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == self.viewModel.dataSource.count - 1) {
        return 8;
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.viewModel.dataSource.count - 1) {
        return 34;
    } else {
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.viewModel.dataSource.count - 1) {
        UIButton *footerView = [UIButton buttonWithType:UIButtonTypeCustom];
        footerView.backgroundColor = [UIColor whiteColor];
        footerView.frame = CGRectMake(0, 0, APPWIDTH, 34);
        [footerView setTitle:@"更多支付方式 ∨" forState:UIControlStateNormal];
        [footerView setTitleColor:TP_TABLE_FOOTER_TITLE_COLOR forState:UIControlStateNormal];
        footerView.titleLabel.font = UIFONTSYSTEM(16);
        [footerView addTarget:self action:@selector(clickTableViewFooterViewButton:) forControlEvents:UIControlEventTouchUpOutside];
        
        return footerView;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0) {
        //FIXME:TODO-- 跳转到收货地址页面
        [self pushToAddressListViewController];
    } else if (section == 2){
        TPPayWayCell *tmpLastCell = [tableView cellForRowAtIndexPath:_lastSelectedIndexPath];
        tmpLastCell.isSelect = NO;
        
        TPPayWayCell *tmpCell = [tableView cellForRowAtIndexPath:indexPath];
        tmpCell.isSelect = YES;
        
        self.viewModel.selectedPayWay = self.viewModel.dataSource[section][row];
        
        _lastSelectedIndexPath = indexPath;
    }
}

//MARK: -- 更多支付方式按钮事件
- (void)clickTableViewFooterViewButton:(UIButton *)sender {
    
}

#pragma mark - 辅助方法
///MARK: --  跳转界面   跳转到地址列表页
- (void)pushToAddressListViewController {
    TPAddressListViewModel *viewModel = [[TPAddressListViewModel alloc] initWithParams:@{YViewModelTitleKey:@"收货地址"}];
    TPShippingAddressListViewController *listController = [[TPShippingAddressListViewController alloc] initWithViewModel:viewModel];
    @weakify(self);
    listController.selectAddressBlock = ^(TPAddressModel *selectedAddressModel) {
        //返回主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            self.myTableHeaderView.addressModel = selectedAddressModel;
        });
    };
    [self.navigationController pushViewController:listController animated:YES];
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
