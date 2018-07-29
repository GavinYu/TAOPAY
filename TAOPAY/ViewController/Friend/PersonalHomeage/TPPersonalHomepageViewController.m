//
//  TPPersonalHomepageViewController.m
//  TAOPAY
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPPersonalHomepageViewController.h"

#import "TPPublishFriendCircleViewController.h"
#import "TPPersonCenterViewController.h"

#import "TPAppConfig.h"

#import "TPPersonalHomepageTableHeaderView.h"
#import "TPPersonalHomepageCell.h"
#import "TPMenuView.h"

#import "TPPersonalHomepageViewModel.h"

#import "TPFriendListModel.h"
#import "TPFriendModel.h"

@interface TPPersonalHomepageViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) TPPersonalHomepageTableHeaderView *myTableHeaderView;
@property (nonatomic, strong) TPMenuView *menuView;

@property (strong, nonatomic) TPPersonalHomepageViewModel *viewModel;

@property (assign, nonatomic) BOOL isHaveInitMenuView;

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

    // create subViews
    [self setupSubViews];
    
    // bind viewModel
    [self bindViewModel];
}

//MARK: -- Tableview 文本内容区域
- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}

#pragma mark - 初始化子控件
- (void)setupSubViews {
//    self.tableView.frame = CGRectMake(0, 0, APPWIDTH, APPHEIGHT);
    [self setupTableHeaderView];
    self.tableView.tableHeaderView = self.myTableHeaderView;
    self.tableView.backgroundColor = TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1;
    //tableView 注册cell 和 headerview
    [self.tableView y_registerNibCell:[TPPersonalHomepageCell class]];
}

//MARK: -- 设置tableview HeaderView
- (void)setupTableHeaderView {
    self.myTableHeaderView = [TPPersonalHomepageTableHeaderView instanceView];
    self.myTableHeaderView.tableHeaderViewType = TPTableHeaderViewTypePersonal;
    
    @weakify(self);
    [self.myTableHeaderView setClickMenuBlock:^(UIButton *sender) {
        @strongify(self);
        if (!self.isHaveInitMenuView) {
            [self createMenuView];
        }
        [self showMenuView:sender.isSelected];
    }];
}

//MARK: -- 创建menu视图
- (void)createMenuView {
    [self.view addSubview:self.menuView];
    
    @weakify(self);
    self.menuView.clickMenuEventBlock = ^(UIButton *sender) {
        @strongify(self);
        //隐藏menuview
        [self showMenuView:NO];
        
        switch (sender.tag) {
            case TPMenuEventTypeMoment:
            {
                TPPublishFriendCircleViewController *tmpPublishFriendCircleController = [[TPPublishFriendCircleViewController alloc] init];
                tmpPublishFriendCircleController.currentUserInfoModel = self.viewModel.userInfoModel;
                [self.navigationController pushViewController:tmpPublishFriendCircleController animated:YES];
//                tmpPublishFriendCircleController.view.frame = CGRectMake(0, APPHEIGHT, APPWIDTH, APPHEIGHT-CGRectGetMaxY(self.myTableHeaderView.frame));
//                [self.view addSubview:tmpPublishFriendCircleController.view];
//
//                __block CGSize weakViewSize = tmpPublishFriendCircleController.view.bounds.size;
//                //发布朋友圈成功后的回调
//                __block TPPublishFriendCircleViewController *weakTmpController = tmpPublishFriendCircleController;
//                tmpPublishFriendCircleController.publishFriendCircleCompletionBlock = ^(BOOL result) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        @strongify(self);
//                        [self destroyPublishFriendCircleView:weakTmpController];
//                        if (result) {
//                            [self.tableView reloadData];
//                        }
//                    });
//                };
//
//                //动画：从下往上push出来
//                [UIView animateWithDuration:.3 animations:^{
//                    tmpPublishFriendCircleController.view.frame = CGRectMake(0, CGRectGetMaxY(self.myTableHeaderView.frame), weakViewSize.width,weakViewSize.height);
//                }];
                
            }
                break;
                
            case TPMenuEventTypeMine:
            {
                
            }
                break;
                
            case TPMenuEventTypeSetting:
            {
                
            }
                break;
                
            default:
                break;
        }
    };
    
    self.isHaveInitMenuView = YES;
}

//MARK: -- 显示/隐藏 Menu视图
- (void)showMenuView:(BOOL)isShow {
    @weakify(self);
    
    [UIView animateWithDuration:.3 animations:^{
        @strongify(self);
        if (isShow) {
            self.menuView.frame = CGRectMake(0, self.menuView.frame.origin.y, self.menuView.bounds.size.width, self.menuView.bounds.size.height);
        } else {
            self.menuView.frame = CGRectMake(-self.menuView.bounds.size.width, self.menuView.frame.origin.y, self.menuView.bounds.size.width, self.menuView.bounds.size.height);
        }
    }];
}

//MARK: -- 销毁发布朋友圈的视图
- (void)destroyPublishFriendCircleView:(TPPublishFriendCircleViewController *)controller {
    __block CGSize tmpViewSize = controller.view.bounds.size;
    __block TPPublishFriendCircleViewController *weakTmpController = controller;
    
    [UIView animateWithDuration:.3 animations:^{
        weakTmpController.view.frame = CGRectMake(0, APPHEIGHT, tmpViewSize.width, tmpViewSize.height);
    } completion:^(BOOL finished) {
        [weakTmpController.view removeFromSuperview];
        weakTmpController = nil;
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
            self.myTableHeaderView.userInfoModel = self.viewModel.userInfoModel;
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
    
    TPFriendModel *rowModel = self.viewModel.dataSource[indexPath.row];
    
    if (_selectedFriendBlock) {
        _selectedFriendBlock(rowModel.username);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK: -- lazyload area
//MARK: -- lazyload addNewAddressView
- (TPMenuView *)menuView {
    if (!_menuView) {
        _menuView = [TPMenuView instanceView];
        _menuView.frame = CGRectMake(-CGRectGetWidth(_menuView.bounds), NAVGATIONBARHEIGHT+15, 60, 90);
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
