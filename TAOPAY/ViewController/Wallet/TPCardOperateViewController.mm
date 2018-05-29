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
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UPPaymentControl.h"


@interface TPCardOperateViewController ()

@property (nonatomic, strong) TPWalletTableFooterView *tableFooterView;

@end

@implementation TPCardOperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubView];
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

//MARK: -- 初始化子视图
- (void)setupSubView {
    
    [self.view bringSubviewToFront:self.navigationView];
    self.navigationItem.title = self.cardOperateViewModel.title;
    self.navigationView.isShowBackButton = YES;
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
                        
                        BOOL tmpPayStatus = [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"UPPayDemo" mode:kMode_Development viewController:self];
                        if (tmpPayStatus) {
                            [self.cardOperateViewModel balanceQuerySuccess:^(id json) {
                                NSString *tmpSuccessMsg = (NSString *)json;
                                [SVProgressHUD showSuccessWithStatus:tmpSuccessMsg];
                            } failure:nil];
                        } else {
                            [SVProgressHUD showSuccessWithStatus:@"支付失败！"];
                        }
                    });
                } failure:nil];
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
                } failure:nil];
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
