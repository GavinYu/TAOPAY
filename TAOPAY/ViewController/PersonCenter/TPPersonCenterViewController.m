//
//  TPPersonCenterViewController.m
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPPersonCenterViewController.h"

#import "TPAppConfig.h"

#import "TPOrderListViewController.h"
#import "TPShippingAddressListViewController.h"
#import "TPSettingViewController.h"
#import "TPSafeCenterViewController.h"

#import "TPOrderListViewModel.h"

@interface TPPersonCenterViewController ()
@property (nonatomic, strong) UIView *myTableFooterView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation TPPersonCenterViewController
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configDataSource];
    // Do any additional setup after loading the view.
    [self configNavigationBar];
    // create subViews
    [self setupSubViews];
    
    
    // bind viewModel
    [self bindViewModel];
}

//MARK: -- config NavigationBar
- (void)configNavigationBar {
    self.navigationView.title = @"个人中心";
    self.navigationView.isShowBackButton = YES;
    self.navigationView.isShowNavRightButtons = YES;
    self.navigationView.isShowDownArrowImage = NO;
    [self.view addSubview:self.navigationView];
    
    @weakify(self);
    self.navigationView.clickHomeHandler = ^(UIButton *sender) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
}

//MARK: -- config datasource
- (void)configDataSource {
    self.dataArray = @[
                       @[@{@"title":@"待付款",@"index":@"TPOrderListViewController",@"type":[NSString                               integerToString:TPOrderTypeObligation]},
                         @{@"title":@"待发货",@"index":@"TPOrderListViewController",@"type":[NSString integerToString:TPOrderTypeWaitDispatch]},
                         @{@"title":@"待收货",@"index":@"TPOrderListViewController",@"type":[NSString integerToString:TPOrderTypeWaitReceiving]},
                         @{@"title":@"待评价",@"index":@"TPOrderListViewController",@"type":[NSString integerToString:TPOrderTypeWaitEvaluate]},
                         @{@"title":@"我的积分",@"index":@"TPOrderListViewController"}],
                       @[@{@"title":@"邀请好友领取积分",@"index":@"TPOrderListViewController"},
                         @{@"title":@"收货地址",@"index":@"TPShippingAddressListViewController"},
                         @{@"title":@"设置",@"index":@"TPSettingViewController"}],
                       @[@{@"title":@"账单",@"index":@"TPOrderListViewController"},
                         @{@"title":@"交易记录",@"index":@"TPOrderListViewController"}],
                       @[@{@"title":@"安全中心",@"index":@"TPSafeCenterViewController"},
                         @{@"title":@"其他",@"index":@"TPOrderListViewController"}]];
}


//MARK: -- 设置tableview FooterView
- (void)setupTableFooterView {
    self.myTableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPWIDTH, 70)];
    self.myTableFooterView.backgroundColor = TP_MAIN_BACKGROUNDCOLOR;
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitButton setTitleColor:TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1 forState:UIControlStateNormal];
    exitButton.titleLabel.font = UIFONTSYSTEM(18.0);
    [exitButton addTarget:self action:@selector(clickExitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.myTableFooterView addSubview:exitButton];
    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myTableFooterView).offset(18);
        make.centerX.equalTo(self.myTableFooterView);
        make.size.mas_equalTo(CGSizeMake(APPWIDTH, 40));
    }];
}

//MARK: -- 退出登录按钮事件
- (void)clickExitButton:(UIButton *)sender {
    
}

#pragma mark - 初始化子控件
- (void)setupSubViews {
    self.tableView.frame = CGRectMake(0, 0, APPWIDTH, APPHEIGHT);
    [self setupTableFooterView];
    self.tableView.tableFooterView = self.myTableFooterView;
    self.tableView.backgroundColor = TP_MAIN_BACKGROUNDCOLOR;
}

#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
    
}

#pragma mark - Override
//MARK: - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    static NSString *CellInentifier = @"UITabeViewCellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellInentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellInentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = UIFONTSYSTEM(16.0);
        cell.textLabel.textColor = TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1;
    }
    
    if (self.dataArray.count > 0) {
        NSArray *tmpSectionArr = self.dataArray[section];
        if (tmpSectionArr.count > 0) {
            NSDictionary *dic = tmpSectionArr[row];
            cell.textLabel.text = dic[@"title"];
        }
    }
    
    return cell;
}

//MARK: -- UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?18:10;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPWIDTH, <#CGFloat height#>)]
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
     NSDictionary *rowDic = self.dataArray[section][row];
    
    switch (section) {
        case 0:
        {
            if (row == [self.dataArray[section] count] -1) {
                //FIXME:TODO -- 跳转到我的积分
                [self turnToNextViewController:rowDic[@"index"]];
            } else {
                [self pushToNextViewController];
            }
        }
            break;
            
        default:
        {
           
            [self turnToNextViewController:rowDic[@"index"]];
        }
            break;
    }
   
}

//MARK: --  跳转界面
- (void)pushToNextViewController {
    TPOrderListViewModel *viewModel = [[TPOrderListViewModel alloc] initWithParams:@{YViewModelTitleKey:@"我的订单"}];
    TPOrderListViewController *publicVC = [[TPOrderListViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:publicVC animated:YES];
}

- (void)turnToNextViewController:(NSString *)controllerIdentifier {
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"PersonCenter" bundle:nil];
    
    UIViewController *tmpController = [mainBoard instantiateViewControllerWithIdentifier:controllerIdentifier];
    [self.navigationController pushViewController:tmpController animated:YES];
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
