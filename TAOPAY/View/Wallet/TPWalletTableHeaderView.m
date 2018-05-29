//
//  TPWalletTableHeaderView.m
//  TAOPAY
//
//  Created by admin on 2018/4/15.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPWalletTableHeaderView.h"

#import "TPWalletTableHeaderViewModel.h"
#import "TPAppConfig.h"

@interface TPWalletTableHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *writeButton;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgCardImageView;
@property (weak, nonatomic) IBOutlet UILabel *checkCodeLabel;

@end

@implementation TPWalletTableHeaderView
{
    FBKVOController *_KVOController;
}

//MARK: -- instance WalletTableHeaderView
+ (TPWalletTableHeaderView *)instanceWalletTableHeaderView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"TPWalletTableHeaderView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubViews];
    
    [self bindViewModel];
}
//MARK: -- Setup subView
- (void)setupSubViews {
    self.balanceLabel.text = self.viewModel.balance;
}
//MARK: --  余额明细按钮事件
- (IBAction)clickdetailButton:(UIButton *)sender {
    if (_clickButtonBlock) {
        _clickButtonBlock(sender.tag);
    }
}
//MARK: --  填写户名按钮事件
- (IBAction)clickWriteUsernameButton:(UIButton *)sender {
    if (_clickButtonBlock) {
        _clickButtonBlock(sender.tag);
    }
}
//MARK: --  添加银行卡按钮事件
- (IBAction)clickAddBankCardButton:(UIButton *)sender {
    if (_clickButtonBlock) {
        _clickButtonBlock(sender.tag);
    }
}

#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
    @weakify(self);
    [_KVOController y_observe:self.viewModel keyPath:@"balance" block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        NSString *tmpBalance = change[NSKeyValueChangeNewKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.balanceLabel.text = tmpBalance;
        });
    }];
    
    [_KVOController y_observe:[YHTTPService sharedInstance] keyPath:@"currentUser" block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        TPUser *tmpUser = change[NSKeyValueChangeNewKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.balanceLabel.text = tmpUser.balance;
            self.tipsLabel.text = [NSString stringWithFormat:@"户名：%@", tmpUser.nick];
            [self.writeButton setTitle:@"修改户名" forState:UIControlStateNormal];
            self.cardNumberLabel.text = tmpUser.cardNum;
            self.dateLabel.text = tmpUser.created_at;
        });
    }];

}

//MARK: -- lazyload
- (TPWalletTableHeaderViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = TPWalletTableHeaderViewModel.new;
        _viewModel.balance = @"105.00";
    }
    
    return _viewModel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
