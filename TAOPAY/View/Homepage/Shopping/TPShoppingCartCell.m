//
//  TPShoppingCartCell.m
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShoppingCartCell.h"

#import "TPAppConfig.h"
#import "TPCartGoodsViewModel.h"
#import "TPShoppingCartGoodsModel.h"

@interface TPShoppingCartCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selectImageView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *goodsCountTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *subButton;

/// viewModle
@property (nonatomic, readwrite, strong) TPCartGoodsViewModel *viewModel;

@end

@implementation TPShoppingCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self _addActionDealForMVCOrMVVMWithoutRAC];
    /// 添加事件
    [self.goodsCountTextField addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 以下 MVVM使用的场景，如果使用MVC的请自行ignore
#pragma mark - bind data
- (void)bindViewModel:(TPCartGoodsViewModel *)viewModel {
    self.viewModel = viewModel;
    
    ///商品图片
    [self.goodsImageView setImageWithURL:[NSURL URLWithString:viewModel.goods.image] placeholder:nil];
    ///商铺名称
    self.goodsNameLabel.text = viewModel.goods.name;
    ///商品价格
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@", viewModel.goods.price];
    ///商品数量
    self.goodsCountTextField.text =  viewModel.goods.count;
    
}

#pragma mark - 事件处理
//// 以下 MVC 和 MVVM without RAC 的事件回调的使用的场景，如果使用MVVM With RAC的请自行ignore
/// 事件处理 我这里使用 block 来回调事件
- (void)_addActionDealForMVCOrMVVMWithoutRAC
{
    /// 选择按钮被点击
    @weakify(self);
    [self.selectImageView bk_addEventHandler:^(id sender) {
        @strongify(self);
        !self.selectBlock?:self.selectBlock(self);
    } forControlEvents:UIControlEventTouchUpOutside];
    
    /// 增加按钮被点击
    [self.addButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        !self.addBlock?:self.addBlock(self);
    } forControlEvents:UIControlEventTouchUpOutside];
    
    /// 减少按钮被点击
    [self.subButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        !self.subBlock?:self.subBlock(self);
    } forControlEvents:UIControlEventTouchUpOutside];
    
    /// 删除按钮被点击
    [self.deleteButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        !self.deleteBlock?:self.deleteBlock(self);
    } forControlEvents:UIControlEventTouchUpOutside];
    
}

//MARK: -- UITextFieldDelegate
//MARK: -- textField的数据改变
- (void)textFieldValueDidChanged:(UITextField *)sender {
    /// bind data
    if ([sender.text integerValue] == 0) {
        [SVProgressHUD showErrorWithStatus:@"数量不能为0"];
        return;
    }
    self.viewModel.goodsCount = sender.text;
    
    ///数字编辑框被编辑
    if (_countBlock) {
        _countBlock(self);
    }
}

//MARK: -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
