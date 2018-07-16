//
//  TPShippingAddressListViewController.m
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShippingAddressListViewController.h"

#import "TPAppConfig.h"
#import "TPShippingAddressCell.h"
#import "YHTTPService.h"
#import "TPAddressListModel.h"
#import "TPAddressModel.h"
#import "TPAreaModel.h"

#import "TPShippingAddressTableFooterView.h"
#import "TPAddNewAddressView.h"
#import "TPAreaListView.h"

#import "TPAddressListViewModel.h"

@interface TPShippingAddressListViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) TPShippingAddressTableFooterView *myTableFooterView;
@property (nonatomic, strong) TPAddNewAddressView *addNewAddressView;
@property (nonatomic, strong) TPAreaListView *areaListView;

@property (nonatomic, strong) TPAddressListModel *addressList;
@property (strong, nonatomic) TPAddressListViewModel *viewModel;

@end

@implementation TPShippingAddressListViewController
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏
    [self configNavigationBar];
    // create subViews
    [self setupSubViews];

    // bind viewModel
    [self bindViewModel];
}

//MARK: -- config NavigationBar
- (void)configNavigationBar {
    self.navigationView.title = self.viewModel.title;
    self.navigationView.isShowBackButton = YES;
    self.navigationView.isShowNavRightButtons = YES;
    self.navigationView.isShowDownArrowImage = NO;
    [self.view addSubview:self.navigationView];
}

#pragma mark - 初始化子控件
- (void)setupSubViews {
    [self setupTableFooterView];
    self.tableView.tableFooterView = self.myTableFooterView;
    self.tableView.backgroundColor = TP_MAIN_BACKGROUNDCOLOR;
    //tableView 注册cell 和 headerview
    [self.tableView y_registerNibCell:[TPShippingAddressCell class]];
}

//MARK: -- 设置tableview FooterView
- (void)setupTableFooterView {
    self.myTableFooterView = [TPShippingAddressTableFooterView instanceShippingAddressTableFooterView];
    
    @weakify(self);
    [self.myTableFooterView setClickAddBlock:^(UIButton *sender) {
        @strongify(self);
        [self showAddNewAddressView];
    }];
}

//MARK: -- 显示添加地址视图
- (void)showAddNewAddressView {
    [self.addNewAddressView show];
    @weakify(self);
    
    self.addNewAddressView.saveNewAddressBlock = ^(BOOL success) {
        @strongify(self);
        if (success) {
            [self tableViewDidTriggerHeaderRefresh];
        }
    };
    
    self.addNewAddressView.selectAreaBlock = ^(UIButton *sender) {
        @strongify(self);
        [self popAreaListView];
    };
}

//MARK: -- 弹出省、市、区/县 选择视图
- (void)popAreaListView {
    [self.areaListView show];
    
    @weakify(self);
    self.areaListView.selectedAreaBlock = ^(TPAreaModel *selectedArea) {
        @strongify(self);
        //FIXME: TODO --
        self.addNewAddressView.selectAreaId = selectedArea.areaID;
        self.addNewAddressView.areaString = [NSString stringWithFormat:@"%@  %@", self.addNewAddressView.areaString, selectedArea.name];
    };
}

#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
    
}

#pragma mark - Override
//MARK: -- 下拉刷新
- (void)tableViewDidTriggerHeaderRefresh {
    /// 先调用父类的加载数据
    [super tableViewDidTriggerHeaderRefresh];
    /// 加载banners data
    @weakify(self);
    [self.viewModel getAddressListSuccess:^(id json) {
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

#pragma mark - Override
//MARK: - UITableViewDataSource Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    TPShippingAddressCell *addressCell = [TPShippingAddressCell cellForTableView:tableView];
    
    if (self.viewModel.dataSource.count > 0) {
        [addressCell displayCellByDataSources:self.viewModel.dataSource[row] rowAtIndexPath:indexPath];

        @weakify(self);
        addressCell.setDefaultBlock = ^(TPAddressModel *addressModel) {
            //
        };
        
        addressCell.setTopBlock = ^(TPAddressModel *addressModel) {
            //
        };
        
        
        addressCell.deleteBlock = ^(TPAddressModel *addressModel) {
            @strongify(self);
            [self.viewModel deleteAddress:addressModel.addressID success:^(id json) {
                BOOL tmp = [json boolValue];
                if (tmp) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        @strongify(self);
                        [self.tableView reloadData];
                    });
                }
            } failure:^(NSString *error) {
        }];
        };
        
        addressCell.editBlock = ^(TPAddressModel *addressModel) {
            //
        };
    }
    
    return addressCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_selectAddressBlock) {
        _selectAddressBlock(self.viewModel.dataSource[indexPath.row]);
    }
}
//MARK: -- 请求网络

//MARK: -- 设置 置顶地址
- (void)requestSetAddressTop {
    //FIXME:TODO--
}

//MARK: -- 设置默认收货地址
- (void)requestSetDefaultAddress {
    //FIXME:TODO--
}

//MARK: -- lazyload area
//MARK: -- lazyload addNewAddressView
- (TPAddNewAddressView *)addNewAddressView {
    if (!_addNewAddressView) {
        _addNewAddressView = [TPAddNewAddressView instanceAddNewAddressView];
        _addNewAddressView.frame = CGRectMake(15, NAVGATIONBARHEIGHT + 38, APPWIDTH-30, 267);
    }
    
    return _addNewAddressView;
}

//MARK: -- lazyload areaListView
- (TPAreaListView *)areaListView {
    if (!_areaListView) {
        _areaListView = [TPAreaListView instanceAreaListView];
        _areaListView.frame = CGRectMake(0, NAVGATIONBARHEIGHT + 200, APPWIDTH-30, APPHEIGHT-NAVGATIONBARHEIGHT-200);
    }
    
    return _areaListView;
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
