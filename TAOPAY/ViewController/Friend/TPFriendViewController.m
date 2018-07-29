//
//  TPFriendViewController.m
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPFriendViewController.h"

#import "TPAppConfig.h"
#import "TPFriendViewModel.h"
#import "TPFriendCell.h"

#import "TPPersonCenterViewController.h"

@interface TPFriendViewController ()

@property (nonatomic, strong) TPFriendViewModel *viewModel;

@end

@implementation TPFriendViewController
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = TPFriendViewModel.new;
    
    
    [self configNavigationBar];
    
    [self setupSubViews];
    // bind viewModel
    [self bindViewModel];
    [self.viewModel requestAuthorizationForAddressBook];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//MARK: -- 设置导航栏
- (void)configNavigationBar {
    self.navigationView.title = TPLocalizedString(@"homepage_addressbook");
    self.navigationView.isShowBackButton = NO;
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

#pragma mark - 初始化子控件
- (void)setupSubViews {
    self.tableView.frame = CGRectMake(0, NAVGATIONBARHEIGHT, APPWIDTH, APPHEIGHT-TPTABBARHEIGHT-NAVGATIONBARHEIGHT);
    //tableView 注册cell 和 headerview
    [self.tableView y_registerNibCell:[TPFriendCell class]];
}

#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
    
    @weakify(self);
    [_KVOController y_observe:self.viewModel keyPath:@"isFinished" block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        BOOL tmp = [change[NSKeyValueChangeNewKey] boolValue];
        if (tmp) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.tableView reloadData];
            });
        }
    }];
}
#pragma mark - Override
//MARK: - UITableViewDataSource Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    TPFriendCell *cell = [TPFriendCell cellForTableView:tableView];
    
    if (self.viewModel.dataSource.count > 0) {
        [cell displayCellByDataSources:self.viewModel.dataSource[row] rowAtIndexPath:indexPath];
    }
    
    //关注按钮事件
    @weakify(self);
    cell.attentionClickedHandler = ^(TPFriendCell *friendCell) {
        @strongify(self);
        //FIXME:TODO -- 因为通讯录里没有userID
        [self.viewModel addFriendWithFriendId:@"" withPhone:friendCell.phoneNumber success:^(id json) {
//            if ([json boolValue]) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
//                });
//            }
        } failure:^(NSString *error) {
        }];
    };
    
    return cell;
}

//MARK: -- UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

//MARK: -- 文本内容区域
- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}

//MARK: -- lazyload area
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
