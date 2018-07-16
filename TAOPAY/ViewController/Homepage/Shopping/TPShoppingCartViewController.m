//
//  TPShoppingCartViewController.m
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShoppingCartViewController.h"

#import "TPAppConfig.h"

#import "TPReceiveAddressView.h"
#import "TPShoppingCartCell.h"
#import "TPShoppingCartBottomView.h"

#import "TPAddressListViewModel.h"
#import "TPShoppingCartViewModel.h"
#import "TPCartGoodsViewModel.h"

#import "TPShippingAddressListViewController.h"
#import "TPShoppingPayViewController.h"
#import "TPPersonCenterViewController.h"

@interface TPShoppingCartViewController ()

@property (nonatomic, strong) TPShoppingCartViewModel *viewModel;
@property (nonatomic, strong) TPShoppingCartBottomView *bottomToolView;
@property (nonatomic, strong) TPReceiveAddressView *myTableHeaderView;

@end

@implementation TPShoppingCartViewController
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
    [self creatBottomToolView];
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
        UIStoryboard *toStoryboard = [UIStoryboard storyboardWithName:@"PersonCenter" bundle:nil];
        UIViewController *toController=[toStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([TPPersonCenterViewController class])];
        [self.navigationController pushViewController:toController animated:YES];
    };
    
    self.navigationView.clickHomeHandler = ^(UIButton *sender) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
}

//MARK: -- 创建底部工具栏
- (void)creatBottomToolView {
    self.bottomToolView = [TPShoppingCartBottomView instanceShoppingCartBottomView];
    [self.view addSubview:self.bottomToolView];
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(APPWIDTH, TABBARHEIGHT));
    }];
    
    @weakify(self);
    self.bottomToolView.accounttBlock = ^(UIButton *sender) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self pushToShoppingPayViewController];
        });
    };
    
    self.bottomToolView.allSelectBlock = ^(UIButton *sender) {
        @strongify(self);
        [self handleBottomToolViewAllSelectedEvent:sender.isSelected];
        [self.tableView reloadData];
    };
}

//MARK: -- 初始化子控件
- (void)setupSubViews {
    self.tableView.frame = CGRectMake(0, NAVGATIONBARHEIGHT, APPWIDTH, APPHEIGHT-NAVGATIONBARHEIGHT);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableHeaderView = [TPReceiveAddressView instanceReceiveAddressView];
    @weakify(self);
    self.myTableHeaderView.tapBlock = ^(UIButton *sender) {
        @strongify(self);
        [self pushToAddressListViewController];
    };
    self.tableView.tableHeaderView = self.myTableHeaderView;
    
    //tableView 注册cell 和 headerview
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TPReceiveAddressView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TPReceiveAddressView class])];
    [self.tableView y_registerNibCell:[TPShoppingCartCell class]];
}

//MARK: -- 处理下方工具栏的全选事件
- (void)handleBottomToolViewAllSelectedEvent:(BOOL)isSelected {
    CGFloat tmpGoodsTotal = 0;
    
    for (TPCartGoodsViewModel *obj in self.viewModel.dataSource) {
        obj.isSelected = isSelected;
        
        tmpGoodsTotal += [obj.goodsTotalPrice floatValue];
    }
    
    if (isSelected) {
        self.bottomToolView.totalMoney = [NSString stringWithFormat:@"%.2f", tmpGoodsTotal];
    } else {
        self.bottomToolView.totalMoney = @"0";
    }
    
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
    [self.viewModel getShoppingCartListSuccess:^(id json) {
        //TODO: --
        @strongify(self);
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.tableView reloadData];
            self.myTableHeaderView.addressModel = self.viewModel.selectAddressModel;
            self.bottomToolView.totalMoney = self.viewModel.totalPayMoney;
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
    
    TPShoppingCartCell *cartCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TPShoppingCartCell class]) forIndexPath:indexPath];
    /// 处理事件
    @weakify(self);
    //选中处理
    cartCell.selectBlock = ^(TPShoppingCartCell *cell) {
        //是否选中处理
        @strongify(self);
        [self handleCellSelectEvent:cell];
    };
    
    //添加商品处理
    cartCell.addBlock = ^(TPShoppingCartCell *cell) {
        //FIXME:TODO -- 添加商品处理
        @strongify(self);
        self.viewModel.modifyType = TPCartModifyTypeAdd;
        
        [self handleCellModifyEventWithCell:cell];
    };
    
    //减去商品处理
    cartCell.subBlock = ^(TPShoppingCartCell *cell) {
        //FIXME:TODO -- 减去商品处理
        @strongify(self);
        self.viewModel.modifyType = TPCartModifyTypeSub;
        [self handleCellModifyEventWithCell:cell];
    };
    
    //修改商品数量处理
    cartCell.countBlock = ^(TPShoppingCartCell *cell) {
        //FIXME:TODO -- 修改商品数量处理
        @strongify(self);
        self.viewModel.modifyType = TPCartModifyTypeCount;
        [self handleCellModifyEventWithCell:cell];
    };
    
    //删除商品处理
    cartCell.deleteBlock = ^(TPShoppingCartCell *cell) {
        //FIXME:TODO -- 删除商品处理
        @strongify(self);
        self.viewModel.modifyType = TPCartModifyTypeCount;
        [self handleCellModifyEventWithCell:cell];
    };
    
    return cartCell;
}

/// config  data
- (void)configureCell:(TPShoppingCartCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(TPCartGoodsViewModel *)object {
    /// config data (PS：由于MVVM主要是View与数据之间的绑定，但是跟 setViewModel: 差不多啦)
    [cell bindViewModel:object];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//MARK: -- Cell 中的按钮事件处理
//MARK: -- 选中事件
- (void)handleCellSelectEvent:(TPShoppingCartCell *)cell {
    if (cell.viewModel.isSelected) {
        if (![self.viewModel.selectedArray containsObject:cell.viewModel]) {
            [self.viewModel.selectedArray addObject:cell.viewModel];
        }
    } else {
        if ([self.viewModel.selectedArray containsObject:cell.viewModel]) {
            [self.viewModel.selectedArray removeObject:cell.viewModel];
        }
    }
    
    BOOL tmpValue = self.viewModel.selectedArray.count == self.viewModel.dataSource.count;
    self.bottomToolView.isAllSelected = tmpValue == YES ? YES:NO;
    [self handleTotalPriceCalculate:cell.viewModel withIsSelected:cell.viewModel.isSelected];
}

//MARK: -- 处理总价的计算
- (void)handleTotalPriceCalculate:(TPCartGoodsViewModel *)goodsViewModel withIsSelected:(BOOL)isSelected {
    CGFloat tmpTotal = [self.viewModel.totalPayMoney floatValue];
    CGFloat tmpGoodsTotal = [goodsViewModel.goodsTotalPrice floatValue];
    
    if (isSelected) {
        tmpTotal += tmpGoodsTotal;
    } else {
        tmpTotal -= tmpGoodsTotal;
    }
    
    self.viewModel.totalPayMoney = [NSString stringWithFormat:@"%.2f", tmpTotal];
    self.bottomToolView.totalMoney = self.viewModel.totalPayMoney;
}
//MARK: -- 购物车修改事件
- (void)handleCellModifyEventWithCell:(TPShoppingCartCell *)cell {
    @weakify(self);
    [self.viewModel modifyShoppingCartWithGoodsViewModel:cell.viewModel success:^(id json) {
        //FIXME:TODO
        @strongify(self);
        BOOL tmp = [json boolValue];
        if (tmp) {
            [self tableViewDidTriggerHeaderRefresh];
        }
        
    } failure:^(NSString *error) {
        //FIXME:TODO
    }];
}
//MARK: -- 购物车删除事件
- (void)handleCellDeleteEventWithCell:(TPShoppingCartCell *)cell {
    @weakify(self);
    [self.viewModel deleteShoppingCartWithGoodsViewModel:cell.viewModel success:^(id json) {
        //FIXME:TODO
        @strongify(self);
        BOOL tmp = [json boolValue];
        if (tmp) {
            [self tableViewDidTriggerHeaderRefresh];
        }
        
    } failure:^(NSString *error) {
        //FIXME:TODO
    }];
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

///MARK: --  跳转界面   跳转到购物车支付页
- (void)pushToShoppingPayViewController {
    TPShoppingCartViewModel *viewModel = [[TPShoppingCartViewModel alloc] initWithParams:@{YViewModelTitleKey:TPLocalizedString(@"navigation_title")}];
    viewModel.isPayPage = YES;
    TPShoppingPayViewController *shoppingPayController = [[TPShoppingPayViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:shoppingPayController animated:YES];
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
