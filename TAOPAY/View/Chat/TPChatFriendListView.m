//
//  TPChatFriendListView.m
//  TAOPAY
//
//  Created by admin on 2018/7/28.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPChatFriendListView.h"

#import "TPAppConfig.h"

#import "TPChatMsgListCell.h"

#import "TPUserInfoListModel.h"
#import "TPUserInfoModel.h"

@interface TPChatFriendListView () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableDictionary *messageDictionary;

@end

@implementation TPChatFriendListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (TPChatFriendListView *)instanceView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initDataSource];
    [self initSubView];
}

#pragma mark - 初始化视图
- (void)initSubView {
    [self initTableView];
}

//MARK: -- 初始化数据
- (void)initDataSource {
    self.dataSource = [[NSMutableArray alloc] init];
    self.messageDictionary = [[NSMutableDictionary alloc] init];

}
//MARK: -- 初始化TableView
- (void)initTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
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

@end
