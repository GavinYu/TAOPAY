//
//  TPPersonalHomepageViewController.m
//  TAOPAY
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPPersonalHomepageViewController.h"


#import "TPAppConfig.h"

#import "TPPersonalHomepageTableHeaderView.h"
#import "TPPersonalHomepageCell.h"
#import "TPMenuView.h"

#import "TPPersonalHomepageViewModel.h"

@interface TPPersonalHomepageViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) TPPersonalHomepageTableHeaderView *myTableHeaderView;
@property (nonatomic, strong) TPMenuView *menuView;

@property (strong, nonatomic) TPPersonalHomepageViewModel *viewModel;

@end

@implementation TPPersonalHomepageViewController
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
    [self setupTableHeaderView];
    self.tableView.tableHeaderView = self.myTableHeaderView;
    self.tableView.backgroundColor = TP_MAIN_BACKGROUNDCOLOR;
    //tableView 注册cell 和 headerview
    [self.tableView y_registerNibCell:[TPPersonalHomepageCell class]];
}

//MARK: -- 设置tableview FooterView
- (void)setupTableHeaderView {
    self.myTableHeaderView = [TPPersonalHomepageTableHeaderView instanceView];
    
    @weakify(self);
    [self.myTableHeaderView setClickMenuBlock:^(UIButton *sender) {
        @strongify(self);
        [self showMenuView:sender.isSelected];
    }];
}

//MARK: -- 显示/隐藏 Menu视图
- (void)showMenuView:(BOOL)isShow {
    [UIView animateWithDuration:.8 animations:^{
        if (isShow) {
            self.menuView.frame = CGRectMake(0, self.menuView.frame.origin.y, self.menuView.bounds.size.width, self.menuView.bounds.size.height);
        } else {
            self.menuView.frame = CGRectMake(-self.menuView.bounds.size.width, self.menuView.frame.origin.y, self.menuView.bounds.size.width, self.menuView.bounds.size.height);
        }
    }];
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
    [self.viewModel getMessageListSuccess:^(id json) {
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
    
    TPPersonalHomepageCell *cell = [TPPersonalHomepageCell cellForTableView:tableView];
    
    if (self.viewModel.dataSource.count > 0) {
        [cell displayCellByDataSources:self.viewModel.dataSource[row] rowAtIndexPath:indexPath];
        
        @weakify(self);
        cell.avatarTapBlock = ^(TPPersonalHomepageCell *personalHomepageCell) {
            //FIXME:TODO --
        };
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//MARK: -- lazyload area
//MARK: -- lazyload addNewAddressView
- (TPMenuView *)menuView {
    if (!_menuView) {
        _menuView = [TPMenuView instanceView];
        _menuView.frame = CGRectMake(-CGRectGetWidth(_menuView.bounds), 53, 60, 90);
    }
    
    return _menuView;
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
