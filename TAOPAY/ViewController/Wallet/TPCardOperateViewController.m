//
//  TPCardOperateViewController.m
//  TAOPAY
//
//  Created by admin on 2018/4/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPCardOperateViewController.h"

#import "TPCardOperateViewModel.h"
#import "TPAppConfig.h"
#import "TPWalletCommonCell.h"
#import "TPWalletTextNumberCell.h"
#import "TPWalletTableFooterView.h"
#import "TPURLConfigure.h"

//UPPay
#import "TPUPPayManager.h"


@interface TPCardOperateViewController ()

@property (nonatomic, strong) TPWalletTableFooterView *tableFooterView;

@end

@implementation TPCardOperateViewController

- (void)dealloc {
    DLog(@"Dealloc:--%@", NSStringFromClass([self class]));
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    [self removeNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    // Do any additional setup after loading the view.
    [self configNavigationBar];
    [self setupSubView];
    
    [self addNotifications];
}

//MARK: -- 添加通知
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePayResultNotification:) name:TPPayResultNotificationKey object:nil];
}

//MARK: -- 移除通知
- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TPPayResultNotificationKey object:nil];
}

//MARK: -- 处理支付结果的通知
- (void)handlePayResultNotification:(NSNotification *)notification {
    //FIXME:TODO --
    DLog(@"支付结果：%@，and 信息：%@", notification.object, notification.userInfo);
    BOOL result = [notification.object boolValue];
    if (result) {
        //FIXME:TODO: -- 暂时不调用
        [self.cardOperateViewModel balanceQuerySuccess:^(id json) {
            NSString *tmpSuccessMsg = (NSString *)json;
            [SVProgressHUD showSuccessWithStatus:tmpSuccessMsg];
        } failure:^(NSError *errorMsg) {
        }];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"支付失败！"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: -- lazyload tableFooterView
- (TPWalletTableFooterView *)tableFooterView {
    if (!_tableFooterView) {
        _tableFooterView = [TPWalletTableFooterView instanceWalletTableFooterView];
    }
    
    return _tableFooterView;
}

//MARK: -- lazyload cardOperateViewModel
- (TPCardOperateViewModel *)cardOperateViewModel {
    if (!_cardOperateViewModel) {
        _cardOperateViewModel = [[TPCardOperateViewModel alloc] init];
    }
    
    return _cardOperateViewModel;
}

//MARK: -- 设置导航栏
- (void)configNavigationBar {
    self.navigationView.title = self.cardOperateViewModel.title;
    self.navigationView.isShowBackButton = YES;
    self.navigationView.isShowNavRightButtons = YES;
    self.navigationView.isShowDownArrowImage = NO;
    [self.view addSubview:self.navigationView];
}

//MARK: -- 初始化子视图
- (void)setupSubView {
    //tableView 注册cell 和 headerview
    [self.tableView y_registerNibCell:[TPWalletCommonCell class]];
    [self.tableView y_registerNibCell:[TPWalletTextNumberCell class]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TPWalletTableFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TPWalletTableFooterView class])];
    
    self.tableView.tableFooterView = self.tableFooterView;
    
    @weakify(self);
    [self.tableFooterView setClickNextButtonBlock:^(UIButton *sender) {
        //FIXME:TODO--
        @strongify(self);
        switch (self.cardOperateViewModel.cardOperateType) {
            case TPCardOperateTypeRecharge:
            {
                @weakify(self);
                [self.cardOperateViewModel balanceRechargeSuccess:^(id json) {
                    @strongify(self);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *tn = (NSString *)json;
                        DLog(@"充值的tn:%@", tn);
                        [[TPUPPayManager sharedUPPayManager] startPay:tn viewController:self completeBlock:^(BOOL result) {
                        }];
                    });
                } failure:^(NSError *errorMsg) {
                }];
            }
                break;
                
            case TPCardOperateTypeTransfer:
            {
                @weakify(self);
                [self.cardOperateViewModel balanceTransferSuccess:^(id json) {
                    @strongify(self);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *balance = (NSString *)json;
                        if (self.backBlock) {
                            self.backBlock(balance);
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                } failure:^(NSError *errorMsg) {
                }];
            }
                break;
                
            case TPCardOperateTypeWithdraw:
            {
                //TODO:
            }
                break;
                
            default:
                break;
        }
        
    }];
}

#pragma mark - Override
//MARK: - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cardOperateViewModel.sectionNumber;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    
    CGFloat tmpHeight = 0;
    switch (section) {
        case 0:
            tmpHeight = 17.0f;
            break;
            
        case 1:
        {
            tmpHeight = 42.0f;
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.textColor = TP_TABLE_HEADER_TITLE_COLOR;
            titleLabel.font = UIFONTSYSTEM(16.0);
            titleLabel.text = _cardOperateViewModel.walletTips;
            [headerView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headerView).offset(14);
                make.centerY.equalTo(headerView);
                make.size.mas_equalTo(CGSizeMake(APPWIDTH-28, 18));
            }];
        }
            
            break;
            
        case 2:
            tmpHeight = 7.0f;
            break;
            
        default:
            break;
    }
    
    headerView.frame = CGRectMake(0, 0, APPWIDTH, tmpHeight);
    headerView.backgroundColor = UICOLOR_FROM_HEXRGB(0xf5f4f9);

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    
    switch (section) {
        case 0:
        {
            TPWalletCommonCell *commonCell = [TPWalletCommonCell cellForTableView:tableView];
            if (_cardOperateViewModel.walletCommonModel) {
                [commonCell displayCellByDataSources:_cardOperateViewModel.walletCommonModel rowAtIndexPath:indexPath];
            }
            
            return commonCell;
        }
            break;
            
        case 1:
        {
            TPWalletTextNumberCell *amountCell = [TPWalletTextNumberCell cellForTableView:tableView];
            amountCell.viewModel = self.cardOperateViewModel;
            if (_cardOperateViewModel.walletKeyValueModel) {
                [amountCell displayCellByDataSources:_cardOperateViewModel.walletKeyValueModel rowAtIndexPath:indexPath];
            }
            
            return amountCell;
        }
            break;
            
        case 2:
        {
            TPWalletTextNumberCell *accountCell = [TPWalletTextNumberCell cellForTableView:tableView];
            accountCell.viewModel = self.cardOperateViewModel;
            if (_cardOperateViewModel.cardKeyValueModel) {
                [accountCell displayCellByDataSources:_cardOperateViewModel.cardKeyValueModel rowAtIndexPath:indexPath];
            }
            
            return accountCell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

//MARK: -- UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return 42.0;
            break;
            
        case 2:
            return 7.0;
            break;
            
        default:
            return 17.0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 76;
            break;
            
        default:
            return 51.0;
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

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
