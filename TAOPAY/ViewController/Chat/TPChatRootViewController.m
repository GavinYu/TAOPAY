//
//  TPChatRootViewController.m
//  TAOPAY
//
//  Created by admin on 2018/7/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPChatRootViewController.h"

#import "TPChatViewController.h"
#import "TPPersonalHomepageViewController.h"

#import "TPPersonalHomepageViewModel.h"

#import "TPAppConfig.h"

#import "TPChatMsgListCell.h"

#import "TPUserInfoListModel.h"
#import "TPUserInfoModel.h"


@interface TPChatRootViewController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableDictionary *messageDictionary;
@property (strong, nonatomic) TPChatViewController *lastChatViewController;

@property (copy, nonatomic) NSString *selectedFriendUsername;

@end

@implementation TPChatRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
    [self configNavigationBar];
    [self initTableView];
    [self getChatMessageListData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.navigationView.title = TPLocalizedString(@"tabbar_chat");
//    [self destroyLastChatSeesion];
}

//MARK: -- 设置导航栏
- (void)configNavigationBar {
    self.navigationView.title = TPLocalizedString(@"tabbar_chat");
    self.navigationView.isShowBackButton = YES;
    self.navigationView.isShowNavRightButtons = YES;
    self.navigationView.isShowDownArrowImage = NO;
    self.navigationView.isHiddenSearchButton = YES;
    self.navigationView.isHiddenHomepageButton = YES;
    self.navigationView.updateMeImageName = @"btn_nav_personalHomepage";
    [self.view addSubview:self.navigationView];

    @weakify(self);
    self.navigationView.clickBackHandler = ^(UIButton *sender) {
        @strongify(self);
        [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
        [self.rdv_tabBarController setSelectedIndex:0];
    };

    self.navigationView.clickMeHandler = ^(UIButton *sender) {
        @strongify(self);
        [self pushToNextViewController];
    };

    self.navigationView.clickHomeHandler = ^(UIButton *sender) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
}

//MARK: -- 销毁聊天会话
- (void)destroyLastChatSeesion {
    if (self.lastChatViewController) {
        [self.lastChatViewController.view removeFromSuperview];
        self.lastChatViewController = nil;
    }
}
///MARK: --  跳转界面
- (void)pushToNextViewController {
    TPPersonalHomepageViewModel *tmpViewModel = [[TPPersonalHomepageViewModel alloc] initWithParams:@{}];
    TPPersonalHomepageViewController *toController = [[TPPersonalHomepageViewController alloc] initWithViewModel:tmpViewModel];

    @weakify(self);
    toController.selectedFriendBlock = ^(NSString *username) {
        @strongify(self);
        self.selectedFriendUsername = username;
    };
    [self.navigationController pushViewController:toController animated:YES];
}
//MARK: -- 配置聊天参数，显示聊天页面
- (void)configChatViewController:(NSString *)username {
    self.navigationView.title = username;
    //销毁上一个会话
    [self destroyLastChatSeesion];

    @weakify(self);
    TPChatViewController *tmpChatViewController = [[TPChatViewController alloc] initWithConversationChatter:username conversationType:EMConversationTypeChat];
    tmpChatViewController.view.frame = CGRectMake(0, NAVGATIONBARHEIGHT, APPWIDTH, APPHEIGHT-NAVGATIONBARHEIGHT);
    [self.view insertSubview:tmpChatViewController.view belowSubview:self.tableView];
    [self.view bringSubviewToFront:tmpChatViewController.chatToolbar];
    [self.view sendSubviewToBack:self.tableView];
    

    tmpChatViewController.addressBookBlock = ^{
        @strongify(self);
        [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
        [self.rdv_tabBarController setSelectedIndex:1];
    };

    self.lastChatViewController = tmpChatViewController;
}

//MARK: -- 初始化数据
- (void)initDataSource {
    self.dataSource = [[NSMutableArray alloc] init];
    self.messageDictionary = [[NSMutableDictionary alloc] init];
    
}
//MARK: -- 初始化TableView
- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVGATIONBARHEIGHT, TPMsgTableViewWidth, APPHEIGHT-TABBARHEIGHT-NAVGATIONBARHEIGHT) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView y_registerNibCell:[TPChatMsgListCell class] forCellReuseIdentifier:NSStringFromClass([TPChatMsgListCell class])];
    
}

//MARK: -- UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//MARK: -- UITabelViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    TPChatMsgListCell *cell = [TPChatMsgListCell cellForTableView:tableView];
    
    if (self.dataSource.count > 0) {
        TPUserInfoModel *rowModel = self.dataSource[row];
        [cell displayCellByDataSources:rowModel rowAtIndexPath:indexPath];
        cell.messageCount = self.messageDictionary[rowModel.username];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;

    TPChatMsgListCell *tmpCell = (TPChatMsgListCell *)[tableView cellForRowAtIndexPath:indexPath];
    tmpCell.messageCount = nil;
    
    TPUserInfoModel *rowModel = self.dataSource[row];
    
    if (_selectedFriendBlock) {
        _selectedFriendBlock(rowModel.username);
    }
    
//    self.selectedFriendUsername = rowModel.username;
}
//MARK: -- 获取用户头像
- (void)getUsersAvatar:(NSArray *)userIds {
    @weakify(self);
    NSString *userIdsStr = [userIds componentsJoinedByString:@","];
    [[YHTTPService sharedInstance] requestGetUserInfoWithPhones:userIdsStr success:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            TPUserInfoListModel *tmpModel = TPUserInfoListModel.new;
            tmpModel = [TPUserInfoListModel modelWithDictionary:response.parsedResult];
            
            if (self.dataSource.count > 0) {
                [self.dataSource removeAllObjects];
            }
            
            [self.dataSource addObjectsFromArray:tmpModel.info];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.tableView reloadData];
                [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            });
        }
    } failure:^(NSString *msg) {
    }];
}

//MARK: -- 获取聊天会话消息列表
- (void)getChatMessageListData {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    @weakify(self);
    [self getUserIdArray:conversations compeletion:^(NSArray *userIds) {
        @strongify(self);
        [self getUsersAvatar:userIds];
    }];
    
}
//MARK: -- 调用环信的SDK获取消息会话列表接口
- (void)getUserIdArray:(NSArray *)conversations compeletion:(void(^)(NSArray *userIds))compele {
    __block NSMutableArray *tmpUserIdArr = [[NSMutableArray alloc] initWithCapacity:conversations.count];
    
    @weakify(self);
    [conversations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        EMConversation *tmpConversation = (EMConversation *)obj;
        [self.messageDictionary setValue:[NSNumber numberWithInt:tmpConversation.unreadMessagesCount] forKey:tmpConversation.conversationId];
        [tmpUserIdArr addObject:tmpConversation.conversationId];
        
        if (*stop == YES) {
            compele(tmpUserIdArr);
        }
    }];
}

//MARK: -- Setter area
//MARK: -- Setter selectedFriendUsername
- (void)setSelectedFriendUsername:(NSString *)selectedFriendUsername {
    if (_selectedFriendUsername != selectedFriendUsername) {
        _selectedFriendUsername = selectedFriendUsername;

        [self configChatViewController:_selectedFriendUsername];
    }
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
