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
#import "TPShippingAddressTableFooterView.h"

@interface TPShippingAddressListViewController ()
@property (nonatomic, strong) TPShippingAddressTableFooterView *myTableFooterView;
@property (nonatomic, strong) TPAddressListModel *addressList;

@end

@implementation TPShippingAddressListViewController
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏
    [self configNavigationBar];
    // create subViews
    [self setupSubViews];
    //获取地址列表
    [self requestAddressList];
    // bind viewModel
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
    [self.myTableFooterView setClickAddBlock:^(UIButton *sender) {
        //FIXME:TODO:
    }];
}

#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
    
}

#pragma mark - Override
//MARK: - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressList.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    TPShippingAddressCell *addressCell = [TPShippingAddressCell cellForTableView:tableView];
    
    if (self.addressList.list.count > 0) {
        [addressCell displayCellByDataSources:self.addressList.list[row] rowAtIndexPath:indexPath];
        
        @weakify(self);
        addressCell.setDefaultBlock = ^(TPAddressModel *addressModel) {
            //
        };
        
        addressCell.setTopBlock = ^(TPAddressModel *addressModel) {
            //
        };
        
        
        addressCell.deleteBlock = ^(TPAddressModel *addressModel) {
            @strongify(self);
            [self requestDeleteAddress:addressModel];
        };
        
        addressCell.editBlock = ^(TPAddressModel *addressModel) {
            //
        };
    }
    
    return addressCell;
}

//MARK: -- 请求网络
//MARK: -- 获取地址列表
- (void)requestAddressList {
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[YHTTPService sharedInstance] requestAddressSuccess:^(YHTTPResponse *response) {
            @strongify(self);
            self.addressList = TPAddressListModel.new;
            self.addressList.list = NSMutableArray.new;
            self.addressList = [TPAddressListModel modelWithDictionary:response.parsedResult];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } failure:^(NSString *msg) {
            
        }];
    });
}

//MARK: -- 删除地址
- (void)requestDeleteAddress:(TPAddressModel *)addressModel {
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[YHTTPService sharedInstance] requestDeleteAddress:addressModel.addressID success:^(YHTTPResponse *response) {
            @strongify(self);
            [self.addressList.list removeObject:addressModel];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } failure:^(NSString *msg) {
            
        }];
    });
}

//MARK: -- 设置 置顶地址
- (void)requestSetAddressTop {
    //FIXME:TODO--
}

//MARK: -- 设置默认收货地址
- (void)requestSetDefaultAddress {
    //FIXME:TODO--
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
