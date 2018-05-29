//
//  TPWalletViewController.m
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPWalletViewController.h"

#import "TPAppConfig.h"
#import "TPWalletTableHeaderView.h"
#import "TPWalletCell.h"
#import "TPWalletModel.h"
#import "TPCardOperateViewController.h"
#import "TPCardOperateViewModel.h"
#import "TPWalletTableHeaderViewModel.h"

//// 全局变量
static UIStatusBarStyle style_ = UIStatusBarStyleDefault;
static BOOL statusBarHidden_ = NO;

@interface TPWalletViewController ()

@property (nonatomic, strong) TPWalletTableHeaderView *myTableHeaderView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TPWalletTableHeaderViewModel *headerViewModel;

@end

@implementation TPWalletViewController
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDataSource];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"钱包";
    // create subViews
    [self setupSubViews];
    
    
    // bind viewModel
    [self bindViewModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationView.isShowBackButton = NO;

    
}

//MARK: -- lazyload dataArray
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

//MARK: -- config datasource
- (void)configDataSource {
    TPWalletModel *item0 = [TPWalletModel new];
    item0.icon = @"icon_recharge";
    item0.content = @"充值";
    [self.dataArray addObject:item0];
    
    TPWalletModel *item1 = [TPWalletModel new];
    item1.icon = @"icon_withdraw";
    item1.content = @"提现";
    [self.dataArray addObject:item1];
    
    TPWalletModel *item2 = [TPWalletModel new];
    item2.icon = @"icon_transfer";
    item2.content = @"转账";
    [self.dataArray addObject:item2];
}

#pragma mark - 初始化子控件
- (void)setupSubViews {
    self.myTableHeaderView = [TPWalletTableHeaderView instanceWalletTableHeaderView];
    self.tableView.tableHeaderView = self.myTableHeaderView;
    [self setupTableHeaderView];
    
    //tableView 注册cell 和 headerview
    [self.tableView y_registerNibCell:[TPWalletCell class]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TPWalletTableHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TPWalletTableHeaderView class])];
    @weakify(self);
    [self.tableView mh_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
        @strongify(self);
        [self.headerViewModel loadUserInfoSuccess:^(id json) {
            //TODO: --
            [self tableViewDidTriggerHeaderRefresh];
            
        } failure:nil];
    }];
}
//MARK: -- 设置tableview headerview
- (void)setupTableHeaderView {
    @weakify(self);
    [self.myTableHeaderView setClickButtonBlock:^(TPButtonEvent buttonEvent) {
        @strongify(self);
        switch (buttonEvent) {
            case TPButtonEventBalanceDetail:
            {
                //TODO:
            }
                break;
                
            case TPButtonEventWriteUsername:
            {
                //TODO:
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"填写户名" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"请输入户名";
                }];
                //确定按钮
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //TODO:
                    self.headerViewModel.nickName = alertController.textFields.firstObject.text;
                    [self.headerViewModel userUpdateNickSuccess:^(id json) {
                        //TODO:
                        if ([json boolValue]) {
                            [SVProgressHUD showSuccessWithStatus:@"修改户名成功"];
                        }
                    } failure:nil];
                    
                }]];
                //取消按钮
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    //TODO:
                    
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
                break;
                
            case TPButtonEventAddBankCard:
            {
                //TODO:
            }
                break;
                
            default:
                break;
        }
    }];
}



#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
    
}

#pragma mark - Override
//MARK: - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    TPWalletCell *flyLogCell = [TPWalletCell cellForTableView:tableView];
    
    if (self.dataArray.count > 0) {
        [flyLogCell displayCellByDataSources:self.dataArray[row] rowAtIndexPath:indexPath];
    }
    
    return flyLogCell;
}

//MARK: -- UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    TPCardOperateType tmpType = (TPCardOperateType)indexPath.row;
    
    TPCardOperateViewController *tmpController = [mainBoard instantiateViewControllerWithIdentifier:NSStringFromClass([TPCardOperateViewController class])];
    tmpController.cardOperateViewModel.cardOperateType = tmpType;
    @weakify(self);
    tmpController.backBlock = ^(id backValue) {
        @strongify(self);
        self.myTableHeaderView.viewModel.balance = (NSString *)backValue;
    };
    [self.navigationController pushViewController:tmpController animated:YES];
}

//MARK: -- lazyload area
//MARK: -- lazyload headerViewModel
- (TPWalletTableHeaderViewModel *)headerViewModel {
    if (!_headerViewModel) {
        _headerViewModel = TPWalletTableHeaderViewModel.new;
    }
    
    return _headerViewModel;
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
