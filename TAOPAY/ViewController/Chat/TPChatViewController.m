//
//  TPChatViewController.m
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPChatViewController.h"

#import "TPAppConfig.h"

#import "TPPersonalHomepageViewController.h"
#import "TPChatRootViewController.h"

#import "TPChatNavigationBarView.h"

#import "TPPersonalHomepageViewModel.h"

#import "TPFriendCircleViewController.h"
#import "TPFriendCircleViewModel.h"

@interface TPChatViewController () <UIAlertViewDelegate,EMClientDelegate, EaseChatBarMoreViewDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
    UIMenuItem *_recallItem;
}

@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic) NSMutableDictionary *emotionDic;
@property (nonatomic, copy) EaseSelectAtTargetCallback selectedCallback;

@property (strong, nonatomic) TPChatNavigationBarView *chatNavigationBarView;

@end

@implementation TPChatViewController

- (void)dealloc {
    [[EMClient sharedClient] removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    self.fd_prefersNavigationBarHidden = YES;
    // Do any additional setup after loading the view.
//    [self configNavigationBar];
    //添加
//    [self addChatFriendAvatarListView];
    
    [self configCustomChatToolView];
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitChat) name:@"ExitChat" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callOutWithChatter" object:nil];
    
    if (self.conversation.type == EMConversationTypeChat) {
        NSUserDefaults *uDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isTyping = [uDefaults boolForKey:@"MessageShowTyping"];
        if (isTyping) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

//MARK: -- 设置导航栏
- (void)configNavigationBar {
    self.title = self.conversation.conversationId;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed:@"icon_loginNavbar_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 17, 50, 10)];
    logoImageView.image = [UIImage imageNamed:@"icon_loginNavbar_detail_logo"];
    [self.navigationController.navigationBar addSubview:logoImageView];
    
    
    UIButton *mineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    mineButton.accessibilityIdentifier = @"mine";
    [mineButton setImage:[UIImage imageNamed:@"btn_nav_personalHomepage"] forState:UIControlStateNormal];
    [mineButton addTarget:self action:@selector(clickMineButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mineButton];
    
    //    self.fd_prefersNavigationBarHidden = YES;
    //    self.view.backgroundColor = [UIColor blueColor];
    //    self.chatNavigationBarView = [TPChatNavigationBarView instanceView];
    //    self.chatNavigationBarView.frame = CGRectMake(0, 0, APPWIDTH, NAVGATIONBARHEIGHT);
    //    self.chatNavigationBarView.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:self.chatNavigationBarView];
    //
    //    self.chatNavigationBarView.title = @"聊天";
    //
    //    @weakify(self);
    //    self.chatNavigationBarView.clickMeHandler = ^(UIButton *sender) {
    //        @strongify(self);
    //        UIStoryboard *toStoryboard = [UIStoryboard storyboardWithName:@"PersonCenter" bundle:nil];
    //        UIViewController *toController=[toStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([TPPersonCenterViewController class])];
    //        [self.navigationController pushViewController:toController animated:YES];
    //    };
}

//MARK: -- 添加聊天会话列表好友头像列表视图
- (void)addChatFriendAvatarListView {
    TPChatRootViewController *tmpController = [[TPChatRootViewController alloc] init];
    tmpController.view.frame = CGRectMake(0, NAVGATIONBARHEIGHT, TPMsgTableViewWidth, APPHEIGHT-TABBARHEIGHT-2*NAVGATIONBARHEIGHT);
    [self.view addSubview:tmpController.view];
    [self.view bringSubviewToFront:self.chatToolbar];
}

//MARK: -- 自定义下方的聊天工具栏
- (void)configCustomChatToolView {
    EaseChatToolbar *tmpView = (EaseChatToolbar *)self.chatToolbar;
    [tmpView updateToolbarItemIndex:0 withNormalImage:@"btn_chat_voice" withSelectedImage:@"btn_chat_voice" withIsLeft:YES];
        [tmpView removeToolbarItemIndex:1 withSide:NO];
    //    [tmpView updateToolbarItemIndex:0 withNormalImage:@"" withSelectedImage:@"" withIsLeft:NO];
    [tmpView updateToolbarItemIndex:0 withNormalImage:@"btn_chat_add" withSelectedImage:@"btn_chat_sub" withIsLeft:NO];
    
    
    //点“+”以后的视图更新
    self.chatBarMoreView.delegate = self;
    [self updateChatBarMoreView];
}
//MARK: -- 更新下方聊天工具栏
- (void)updateChatBarMoreView {
    UIImage *tmpPhotoImage = [UIImage imageNamed:@"btn_chat_photo"];
    [self.chatBarMoreView updateItemWithImage:tmpPhotoImage highlightedImage:tmpPhotoImage title:@"" atIndex:0];
    
    UIImage *tmpTakePhotoImage = [UIImage imageNamed:@"btn_chat_camera"];
    [self.chatBarMoreView updateItemWithImage:tmpTakePhotoImage highlightedImage:tmpTakePhotoImage title:@"" atIndex:2];
    
    UIImage *tmpRedPacketImage = [UIImage imageNamed:@"btn_chat_integral"];
    [self.chatBarMoreView updateItemWithImage:tmpRedPacketImage highlightedImage:tmpRedPacketImage title:@"" atIndex:1];
//    [self.chatBarMoreView insertItemWithImage:tmpRedPacketImage highlightedImage:tmpRedPacketImage title:@""];
    
    UIImage *tmpAddressBookImage = [UIImage imageNamed:@"btn_chat_friends"];
    [self.chatBarMoreView updateItemWithImage:tmpAddressBookImage highlightedImage:tmpAddressBookImage title:@"" atIndex:3];
//    [self.chatBarMoreView insertItemWithImage:tmpAddressBookImage highlightedImage:tmpAddressBookImage title:@""];
    
    UIImage *tmpFriendCircleImage = [UIImage imageNamed:@"btn_chat_moments"];
    [self.chatBarMoreView updateItemWithImage:tmpFriendCircleImage highlightedImage:tmpFriendCircleImage title:@"" atIndex:4];
//    [self.chatBarMoreView insertItemWithImage:tmpFriendCircleImage highlightedImage:tmpFriendCircleImage title:@""];
}

//MARK: -- 导航栏右边按钮事件
- (void)clickMineButton:(UIButton *)sender {
    //FIXME:TODO -- 跳转到我的个人主页
//    [self pushToNextViewController];
}

#pragma mark - 辅助方法
///MARK: --  跳转界面
- (void)pushToFriendCircleController {
    TPFriendCircleViewModel *tmpViewModel = [[TPFriendCircleViewModel alloc] initWithParams:@{}];
    TPFriendCircleViewController *toController = [[TPFriendCircleViewController alloc] initWithViewModel:tmpViewModel];
    [self.navigationController pushViewController:toController animated:YES];
}

//MARK: -- tableview 刷新
- (void)tableViewDidTriggerHeaderRefresh
{
    //    if ([[ChatDemoHelper shareHelper] isFetchHistoryChange]) {
    //        NSString *startMessageId = nil;
    //        if ([self.messsagesSource count] > 0) {
    //            startMessageId = [(EMMessage *)self.messsagesSource.firstObject messageId];
    //        }
    //
    //        NSLog(@"startMessageID ------- %@",startMessageId);
    //        [EMClient.sharedClient.chatManager asyncFetchHistoryMessagesFromServer:self.conversation.conversationId
    //                                                              conversationType:self.conversation.type
    //                                                                startMessageId:startMessageId
    //                                                                      pageSize:10
    //                                                                    completion:^(EMCursorResult *aResult, EMError *aError)
    //         {
    //             [super tableViewDidTriggerHeaderRefresh];
    //         }];
    //
    //    } else {
    [super tableViewDidTriggerHeaderRefresh];
    //    }
}

//MARK: --  EaseChatBarMoreViewDelegate

/*!
 @method
 @brief 发积分红包
 @discussion
 @param moreView 功能view
 @result
 */
- (void)moreViewLocationAction:(EaseChatBarMoreView *)moreView {
    //FIXME: TODO -- 发积分红包
    
}

/*!
 @method
 @brief 拨打实时语音
 @discussion
 @param moreView 功能view
 @result
 */
- (void)moreViewAudioCallAction:(EaseChatBarMoreView *)moreView {
    //FIXME:TODO -- 跳转到通讯录
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
    [self.rdv_tabBarController setSelectedIndex:1];
}

/*!
 @method
 @brief 跳转到朋友圈
 @discussion
 @param moreView 功能view
 @result
 */
- (void)moreViewVideoCallAction:(EaseChatBarMoreView *)moreView {
    //FIXME:TODO -- 跳转到朋友圈
    [self pushToFriendCircleController];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.messageTimeIntervalTag = -1;
        [self.conversation deleteAllMessages:nil];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        
        [self.tableView reloadData];
    }
}

#pragma mark - EaseMessageCellDelegate

- (void)messageCellSelected:(id<IMessageModel>)model
{
    
    [super messageCellSelected:model];
    
}

#pragma mark - EaseMessageViewControllerDelegate

- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel
{
    NSDictionary *ext = messageModel.message.ext;
    if ([ext objectForKey:@"em_recall"]) {
        NSString *TimeCellIdentifier = [EaseMessageTimeCell cellIdentifier];
        EaseMessageTimeCell *recallCell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        
        if (recallCell == nil) {
            recallCell = [[EaseMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier];
            recallCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        EMTextMessageBody *body = (EMTextMessageBody*)messageModel.message.body;
        recallCell.title = body.text;
        return recallCell;
    }
    return nil;
}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth
{
    NSDictionary *ext = messageModel.message.ext;
    if ([ext objectForKey:@"em_recall"]) {
        return self.timeCellHeight;
    }
    return 0;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[EaseMessageCell class]]) {
            [cell becomeFirstResponder];
            self.menuIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
        }
    }
    return YES;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
    
}

- (void)messageViewController:(EaseMessageViewController *)viewController
    didSelectCallMessageModel:(id<IMessageModel>)messageModel
{
    
}

- (void)messageViewController:(EaseMessageViewController *)viewController
               selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback
{
    _selectedCallback = selectedCallback;
    
}

#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    
    model.failImageName = @"imageDownloadFail";
    
    return model;
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    NSMutableArray *emotionGifs = [NSMutableArray array];
    _emotionDic = [NSMutableDictionary dictionary];
    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
    int index = 0;
    for (NSString *name in names) {
        index++;
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"[示例%d]",index] emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionGifs addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
    }
    EaseEmotionManager *managerGif= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs tagImage:[UIImage imageNamed:@"icon_002_cover"]];
    
    return @[managerDefault,managerGif];
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

- (void)messageViewControllerMarkAllMessagesAsRead:(EaseMessageViewController *)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
}

#pragma mark - EMClientDelegate

- (void)userAccountDidLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userAccountDidRemoveFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userDidForbidByServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

#pragma mark - EMChatManagerDelegate

- (void)messagesDidRecall:(NSArray *)aMessages
{
    for (EMMessage *msg in aMessages) {
        if (![self.conversation.conversationId isEqualToString:msg.conversationId]){
            continue;
        }
        
        NSString *text;
        if ([msg.from isEqualToString:[EMClient sharedClient].currentUsername]) {
            text = [NSString stringWithFormat:NSLocalizedString(@"message.recall", @"You recall a message")];
        } else {
            text = [NSString stringWithFormat:NSLocalizedString(@"message.recallByOthers", @"%@ recall a message"),msg.from];
        }
        
        [self _recallWithMessage:msg text:text isSave:NO];
    }
}

#pragma mark - KeyBoard

- (void)keyBoardWillHide:(NSNotification *)note
{
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"TypingEnd"];
    body.isDeliverOnlineOnly = YES;
    EMMessage *msg = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:from to:self.conversation.conversationId body:body ext:nil];
    [[EMClient sharedClient].chatManager sendMessage:msg progress:nil completion:nil];
}

#pragma mark - action
- (void)backAction
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:NO completion:nil];
        }
    }
    
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
    [self.rdv_tabBarController setSelectedIndex:0];
}

- (void)recallMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        __weak typeof(self) weakSelf = self;
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        [[EMClient sharedClient].chatManager recallMessage:model.message
                                                completion:^(EMMessage *aMessage, EMError *aError) {
                                                    if (!aError) {
                                                        [weakSelf _recallWithMessage:aMessage text:NSLocalizedString(@"message.recall", @"You recall a message") isSave:YES];
                                                    } else {
                                                        [weakSelf showHint:[NSString stringWithFormat:NSLocalizedString(@"recallFailed", @"Recall failed:%@"), aError.errorDescription]];
                                                    }
                                                    weakSelf.menuIndexPath = nil;
                                                }];
    }
}

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - NSNotification

- (void)exitChat
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessageToDataSource:message progress:nil];
        [[EMClient sharedClient].chatManager importMessages:@[message] completion:nil];
    }
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isViewDidAppear = NO;
    } else {
        //结束call
        self.isViewDidAppear = YES;
    }
}

#pragma mark - private

- (void)_recallWithMessage:(EMMessage *)msg text:(NSString *)text isSave:(BOOL)isSave
{
    EMMessage *message = [EaseSDKHelper getTextMessage:text to:msg.conversationId messageType:msg.chatType messageExt:@{@"em_recall":@(YES)}];
    message.isRead = YES;
    [message setTimestamp:msg.timestamp];
    [message setLocalTime:msg.localTime];
    id<IMessageModel> newModel = [[EaseMessageModel alloc] initWithMessage:message];
    __block NSUInteger index = NSNotFound;
    [self.dataArray enumerateObjectsUsingBlock:^(EaseMessageModel *model, NSUInteger idx, BOOL *stop){
        if ([model conformsToProtocol:@protocol(IMessageModel)]) {
            if ([msg.messageId isEqualToString:model.message.messageId])
            {
                index = idx;
                *stop = YES;
            }
        }
    }];
    if (index != NSNotFound) {
        __block NSUInteger sourceIndex = NSNotFound;
        [self.messsagesSource enumerateObjectsUsingBlock:^(EMMessage *message, NSUInteger idx, BOOL *stop){
            if ([message isKindOfClass:[EMMessage class]]) {
                if ([msg.messageId isEqualToString:message.messageId])
                {
                    sourceIndex = idx;
                    *stop = YES;
                }
            }
        }];
        if (sourceIndex != NSNotFound) {
            [self.messsagesSource replaceObjectAtIndex:sourceIndex withObject:newModel.message];
        }
        [self.dataArray replaceObjectAtIndex:index withObject:newModel];
        [self.tableView reloadData];
    }
    
    if (isSave) {
        [self.conversation insertMessage:message error:nil];
    }
}

#pragma mark - Public

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    
    if (_transpondMenuItem == nil) {
        _transpondMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"transpond", @"Transpond") action:@selector(transpondMenuAction:)];
    }
    
    if (_recallItem == nil) {
        _recallItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"recall", @"Recall") action:@selector(recallMenuAction:)];
    }
    
    NSMutableArray *items = [NSMutableArray array];
    
    if (messageType == EMMessageBodyTypeText) {
        [items addObject:_copyMenuItem];
        [items addObject:_transpondMenuItem];
        [items addObject:_deleteMenuItem];
    } else if (messageType == EMMessageBodyTypeImage || messageType == EMMessageBodyTypeVideo) {
        [items addObject:_transpondMenuItem];
        [items addObject:_deleteMenuItem];
    } else {
        [items addObject:_deleteMenuItem];
    }
    
    id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
    if (model.isSender) {
        [items addObject:_recallItem];
    }
    
    [self.menuController setMenuItems:items];
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}

- (void)reloadDingCellWithAckMessageId:(NSString *)aMessageId
{
    if ([aMessageId length] == 0) {
        return;
    }
    
    __block NSUInteger index = NSNotFound;
    __block EaseMessageModel *msgModel = nil;
    [self.dataArray enumerateObjectsUsingBlock:^(EaseMessageModel *model, NSUInteger idx, BOOL *stop){
        if ([model conformsToProtocol:@protocol(IMessageModel)] && [aMessageId isEqualToString:model.message.messageId]) {
            msgModel = model;
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index != NSNotFound) {
        msgModel.dingReadCount += 1;
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
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
