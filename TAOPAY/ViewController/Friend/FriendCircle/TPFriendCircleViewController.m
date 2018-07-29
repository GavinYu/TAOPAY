//
//  TPFriendCircleViewController.m
//  TAOPAY
//
//  Created by admin on 2018/7/28.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPFriendCircleViewController.h"

#import "TPPublishFriendCircleViewController.h"
#import "TPPersonCenterViewController.h"

#import "TPAppConfig.h"

#import "TPPersonalHomepageTableHeaderView.h"
#import "FriendCircleCell.h"
#import "TPMenuView.h"

#import "TPFriendCircleViewModel.h"
#import "TPFriendCircleItemViewModel.h"

@interface TPFriendCircleViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) TPPersonalHomepageTableHeaderView *myTableHeaderView;
@property (nonatomic, strong) TPMenuView *menuView;

@property (strong, nonatomic) TPFriendCircleViewModel *viewModel;

@end

@implementation TPFriendCircleViewController
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
    self.tableView.backgroundColor = TP_MAIN_BACKGROUNDCOLOR;
    //tableView 注册cell 和 headerview
    [self.tableView y_registerNibCell:[FriendCircleCell class]];
}

//MARK: -- 设置tableview HeaderView
- (void)setupTableHeaderView {
    self.myTableHeaderView = [TPPersonalHomepageTableHeaderView instanceView];
    self.myTableHeaderView.tableHeaderViewType = TPTableHeaderViewTypeFriendCircle;
    @weakify(self);
    [self.myTableHeaderView setClickMenuBlock:^(UIButton *sender) {
        @strongify(self);
        [self.view addSubview:self.menuView];
        [self showMenuView:sender.isSelected];
    }];
    
}

//MARK: -- 显示/隐藏 Menu视图
- (void)showMenuView:(BOOL)isShow {
    @weakify(self);
    self.menuView.clickMenuEventBlock = ^(UIButton *sender) {
        @strongify(self);
        switch (sender.tag) {
            case TPMenuEventTypeMoment:
            {
                TPPublishFriendCircleViewController *tmpPublishFriendCircleController = [[TPPublishFriendCircleViewController alloc] init];
                tmpPublishFriendCircleController.view.frame = CGRectMake(0, APPHEIGHT, APPWIDTH, APPHEIGHT-CGRectGetMaxY(self.myTableHeaderView.frame));
                [self.view addSubview:tmpPublishFriendCircleController.view];
                
                __block CGSize weakViewSize = tmpPublishFriendCircleController.view.bounds.size;
                //发布朋友圈成功后的回调
                __block TPPublishFriendCircleViewController *weakTmpController = tmpPublishFriendCircleController;
                tmpPublishFriendCircleController.publishFriendCircleCompletionBlock = ^(BOOL result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        @strongify(self);
                        [self destroyPublishFriendCircleView:weakTmpController];
                        if (result) {
                            [self.tableView reloadData];
                        }
                    });
                };
                
                //动画：从下往上push出来
                [UIView animateWithDuration:.3 animations:^{
                    tmpPublishFriendCircleController.view.frame = CGRectMake(0, CGRectGetMaxY(self.myTableHeaderView.frame), weakViewSize.width,weakViewSize.height);
                }];
                
            }
                break;
                
            case TPMenuEventTypeMine:
            {
                [self.navigationController popViewControllerAnimated:YES];
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
    [UIView animateWithDuration:.3 animations:^{
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
    [self.viewModel getFriendCircleListSuccess:^(id json) {
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
/// config  cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    FriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FriendCircleCell class]) forIndexPath:indexPath];
    /// 处理事件
    @weakify(self);
    //选中处理
    cell.tapAvatarBlock = ^(FriendCircleCell *cell) {
        @strongify(self);
        //FIXME:TODO -- 点击头像进入好友的个人首页
    };
    
    return cell;
}

/// config  data
- (void)configureCell:(FriendCircleCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(TPFriendCircleItemViewModel *)object {
    /// config data (PS：由于MVVM主要是View与数据之间的绑定，但是跟 setViewModel: 差不多啦)
    [cell bindViewModel:object];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 270;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
