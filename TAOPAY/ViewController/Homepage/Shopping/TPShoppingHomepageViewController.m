//
//  TPShoppingHomepageViewController.m
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShoppingHomepageViewController.h"

#import "TPAppConfig.h"

#import "TPShopListViewController.h"
#import "TPGoodsDetailsViewController.h"

#import "TPShoppingTableHeaderView.h"
#import "TPShopCell.h"

#import "TPShopMainViewModel.h"
#import "TPShopListViewModel.h"
#import "TPGoodsViewModel.h"

#import "TPGoodsDetailsViewModel.h"

@interface TPShoppingHomepageViewController ()

@property (nonatomic, strong) TPShoppingTableHeaderView *myTableHeaderView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TPShopMainViewModel *viewModel;

@end

@implementation TPShoppingHomepageViewController
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
    self.navigationView.title = TPLocalizedString(@"homepage_shopping");
    self.navigationView.isShowBackButton = YES;
    self.navigationView.isShowNavRightButtons = YES;
    self.navigationView.isShowDownArrowImage = NO;
    [self.view addSubview:self.navigationView];
}

//MARK: -- 初始化子控件
- (void)setupSubViews {
    self.tableView.frame = CGRectMake(0, NAVGATIONBARHEIGHT, APPWIDTH, APPHEIGHT-NAVGATIONBARHEIGHT);
    self.myTableHeaderView = [TPShoppingTableHeaderView instanceShoppingTableHeaderView];
    self.myTableHeaderView.viewModel = self.viewModel;
    self.tableView.tableHeaderView = self.myTableHeaderView;
    
    [self setupTableHeaderView];
    
    //tableView 注册cell 和 headerview
    [self.tableView y_registerNibCell:[TPShopCell class]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TPShoppingTableHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TPShoppingTableHeaderView class])];
    
}
//MARK: -- 设置tableview headerview
- (void)setupTableHeaderView {
    @weakify(self);
    [self.myTableHeaderView setClickBannerBlock:^(NSInteger bannerIndex) {
        //FIXME:TODO:
        @strongify(self);
        
    }];
    
    [self.myTableHeaderView setClickToolBlock:^(NSInteger itemIndex) {
        //FIXME:TODO:
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            NSString *cat1 = self.viewModel.cat1Array[itemIndex-101];
            //FIXME:TODO:---
            [self turnToShopList:@""];
        });
    }];
    
    [self.myTableHeaderView setClickADBlock:^(NSInteger adIndex) {
        //FIXME:TODO:
        @strongify(self);
        
    }];

}

//MARK: -- 跳转到店铺列表页
- (void)turnToShopList:(NSString *)cat1 {
    TPShopListViewModel *viewModel = [[TPShopListViewModel alloc] initWithParams:@{YViewModelIDKey:cat1, YViewModelTitleKey:TPLocalizedString(@"navigation_title")}];
    TPShopListViewController *listController = [[TPShopListViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:listController animated:YES];
}

#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
    
    @weakify(self);
    [_KVOController y_observe:self.viewModel keyPath:@"bannerData" block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        NSArray *tmp = (NSArray *)change[NSKeyValueChangeNewKey];
        if (!YArrayIsEmpty(tmp)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                self.myTableHeaderView.bannerArray = tmp;
                DLog(@"轮播图：%@", tmp);
            });
        }
        
    }];
    
    [_KVOController y_observe:self.viewModel keyPath:@"adData" block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        NSArray *tmp = (NSArray *)change[NSKeyValueChangeNewKey];
        if (!YArrayIsEmpty(tmp)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                self.myTableHeaderView.adsArray = tmp;
                DLog(@"广告图：%@", tmp);
            });
        }
        
    }];
}
//MARK: -- 请求网络数据
//MARK: -- 加载首页数据
- (void)requestShopHomepageData {
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[YLocationManager sharedLocationManager] startLocation];
        [[YLocationManager sharedLocationManager] setStartLocationBlock:^(YLocationModel * _Nullable locationDataModel) {
            @strongify(self);
            self.viewModel.currentLocationModel = locationDataModel;
            [self tableViewDidTriggerHeaderRefresh];
        }];
    });
}
#pragma mark - Override
//MARK: -- 下拉刷新
- (void)tableViewDidTriggerHeaderRefresh {
    /// 先调用父类的加载数据
    [super tableViewDidTriggerHeaderRefresh];
    /// 加载banners data
    @weakify(self);
    [self.viewModel getShopMainSuccess:^(id json) {
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
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.viewModel.dataSource.count;
//}
/// config  cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    TPShopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TPShopCell class])];
    /// 处理事件
  
    return cell;
}

/// config  data
- (void)configureCell:(TPShopCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(TPGoodsViewModel *)object {
    /// config data (PS：由于MVVM主要是View与数据之间的绑定，但是跟 setViewModel: 差不多啦)
    [cell bindViewModel:object];
}

/// 文本内容区域
- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    TPGoodsViewModel *itemGoodsViewModel = self.viewModel.dataSource[row]
    ;    // 跳转到商品详请
    [self pushToGoodsDetailsViewController:itemGoodsViewModel.goodsID];
}

#pragma mark - 辅助方法
///MARK: --  跳转界面
- (void)pushToGoodsDetailsViewController:(NSString *)goodsID
{
    TPGoodsDetailsViewModel *viewModel = [[TPGoodsDetailsViewModel alloc] initWithParams:@{YViewModelIDKey:goodsID}];
    TPGoodsDetailsViewController *publicVC = [[TPGoodsDetailsViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:publicVC animated:YES];
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
