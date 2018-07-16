//
//  TPGoodsDetailsViewController.m
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPGoodsDetailsViewController.h"

#import "TPGoodsDetailTopToolView.h"
#import "TPGoodsDetailBottomView.h"
#import "TPGoodsDetailTableHeaderView.h"
#import "TPGoodsDetailsCell.h"
#import "TPGoodsDetailInfoCell.h"

#import "TPGoodsDetailsViewModel.h"
#import "TPShoppingCartViewModel.h"

#import "TPAppConfig.h"

#import "TPShoppingPayViewController.h"
#import "TPShoppingCartViewController.h"

@interface TPGoodsDetailsViewController ()

@property (strong, nonatomic) TPGoodsDetailTopToolView *navToolView;
@property (strong, nonatomic) TPGoodsDetailBottomView *bottomToolView;
@property (strong, nonatomic) TPGoodsDetailTableHeaderView *myTableHeaderView;
@property (strong, nonatomic) TPGoodsDetailsViewModel *viewModel;

@end

@implementation TPGoodsDetailsViewController
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatNavToolView];
    [self setupSubViews];
    [self creatBottomToolView];
    
    [self bindViewModel];
}

/// 文本内容区域
- (UIEdgeInsets)contentInset
{
    return UIEdgeInsetsZero;
}

//MARK: -- 创建导航栏工具栏
- (void)creatNavToolView {
    self.navToolView = [TPGoodsDetailTopToolView instanceGoodsDetailTopToolView];
    [self.view addSubview:self.navToolView];
    [self.navToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(APPWIDTH, NAVGATIONBARHEIGHT));
    }];
    
    @weakify(self);
    self.navToolView.clickBackBlock = ^(UIButton *sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    self.navToolView.clickShareBlock = ^(UIButton *sender) {
        //FIXME:TODO: -- 需要弹出分享视图
    };
}

//MARK: -- 创建底部工具栏
- (void)creatBottomToolView {
    self.bottomToolView = [TPGoodsDetailBottomView instanceGoodsDetailBottomView];
    [self.view addSubview:self.bottomToolView];
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(APPWIDTH, TABBARHEIGHT));
    }];
    
    @weakify(self);
    self.bottomToolView.collectBlock = ^(UIButton *sender) {
        @strongify(self);
        [self.viewModel addGoodsToShoppingCartSuccess:^(id json) {
            @strongify(self);
            BOOL tmp = [json boolValue];
            if (tmp) {
                [self turnToShoppingCart];
            }
        } failure:^(NSString *error) {
        }];
    };
    
    self.bottomToolView.serviceBlock = ^(UIButton *sender) {
        //FIXME:TODO: -- 需要跳转到客服页面
    };
    
    self.bottomToolView.intagralBuyBlock = ^(UIButton *sender) {
        @strongify(self);
        [self.viewModel addGoodsToShoppingCartSuccess:^(id json) {
            @strongify(self);
            BOOL tmp = [json boolValue];
            if (tmp) {
                //跳转到购物支付页
                [self turnToShoppingPay];
            }
        } failure:^(NSString *error) {
        }];
    };
    
    self.bottomToolView.buyBlock = ^(UIButton *sender) {
        @strongify(self);
        [self.viewModel addGoodsToShoppingCartSuccess:^(id json) {
            @strongify(self);
            BOOL tmp = [json boolValue];
            if (tmp) {
                //跳转到购物支付页
                [self turnToShoppingPay];
            }
        } failure:^(NSString *error) {
        }];
    };
}

//MARK: -- 初始化子控件
- (void)setupSubViews {
    self.tableView.frame = CGRectMake(0, STATUSBARHEIGHT, APPWIDTH, APPHEIGHT-TABBARHEIGHT-STATUSBARHEIGHT);
    [self setupTableHeaderView];
    //tableView 注册cell 和 headerview
    [self.tableView y_registerNibCell:[TPGoodsDetailsCell class]];
    [self.tableView y_registerNibCell:[TPGoodsDetailInfoCell class]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TPGoodsDetailTableHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TPGoodsDetailTableHeaderView class])];
    
}
//MARK: -- 设置tableview headerview
- (void)setupTableHeaderView {
    self.myTableHeaderView = [TPGoodsDetailTableHeaderView instanceGoodsDetailTableHeaderView];
    self.tableView.tableHeaderView = self.myTableHeaderView;
}

#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
    
}

//MARK: -- 跳转到购物支付页
- (void)turnToShoppingPay {
    TPShoppingCartViewModel *viewModel = [[TPShoppingCartViewModel alloc] initWithParams:@{YViewModelTitleKey:TPLocalizedString(@"navigation_title")}];
    viewModel.isPayPage = YES;
    TPShoppingPayViewController *shopPayController = [[TPShoppingPayViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:shopPayController animated:YES];
}

//MARK: -- 跳转到购物车页
- (void)turnToShoppingCart {
    TPShoppingCartViewModel *viewModel = [[TPShoppingCartViewModel alloc] initWithParams:@{YViewModelTitleKey:@"购物车"}];
    TPShoppingCartViewController *toyController = [[TPShoppingCartViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:toyController animated:YES];
}
//MARK: -- 请求网络数据
#pragma mark - Override
//MARK: -- 下拉刷新
- (void)tableViewDidTriggerHeaderRefresh {
    /// 先调用父类的加载数据
    [super tableViewDidTriggerHeaderRefresh];
    /// 加载banners data
    @weakify(self);
    [self.viewModel getGoodsDetailSuccess:^(id json) {
        //TODO: --
        @strongify(self);
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.tableView reloadData];
            self.myTableHeaderView.imageArray = self.viewModel.goodsImageArray;
            [self.bottomToolView configData:self.viewModel.goodsInfoModel];
        });
    } failure:^(NSString *error) {
        @strongify(self);
        [self tableViewDidFinishTriggerHeader:YES reload:NO];
    }];
}

#pragma mark - Override
//MARK: - UITableViewDataSource Methods
/// config  cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (self.viewModel.goodsInfoModel) {
        if (section == 0) {
            TPGoodsDetailsCell *detailCell = [TPGoodsDetailsCell cellForTableView:tableView];
            [detailCell displayCellByDataSources:self.viewModel.dataSource[section][row] rowAtIndexPath:indexPath];
            
            return detailCell;
        } else {
            TPGoodsDetailInfoCell *detailInfoCell = [TPGoodsDetailInfoCell cellForTableView:tableView];
            [detailInfoCell displayCellByDataSources:self.viewModel.dataSource[section][row] rowAtIndexPath:indexPath];
            
            return detailInfoCell;
        }
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 221;
    } else {
        return 392;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
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
