//
//  TPShopCell.m
//  TAOPAY
//
//  Created by admin on 2018/5/21.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShopCell.h"

#import "TPGoodsViewModel.h"
#import "TPAppConfig.h"
#import "TPGoodsModel.h"

@interface TPShopCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsOriginalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellNumberLabel;

/// viewModle
@property (nonatomic, readwrite, strong) TPGoodsViewModel *viewModel;

@end

@implementation TPShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 以下 MVVM使用的场景，如果使用MVC的请自行ignore
#pragma mark - bind data
- (void)bindViewModel:(TPGoodsViewModel *)viewModel {
    self.viewModel = viewModel;

    ///商品图片
    [self.goodsImageView setImageWithURL:[NSURL URLWithString:viewModel.goods.image] placeholder:nil];
    /// 商品名称
    self.goodsNameLabel.text = viewModel.goods.name;
    //商品简介
    self.goodsInfoLabel.text = viewModel.goods.info;
    /// 距离
    self.distanceLabel.text =  viewModel.goods.distance;
    ///已售数量
    self.sellNumberLabel.text = [NSString stringWithFormat:@"已售%@", viewModel.goods.count?:@"0"];
    /// 卖价
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@", viewModel.goods.price];
    CGFloat priceWidth = [YUtil getTextWidthWithContent:self.goodsPriceLabel.text withContentSizeOfHeight:self.goodsPriceLabel.bounds.size.height withAttribute:@{NSFontAttributeName:self.goodsPriceLabel.font}];
    [self.goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(10);
        make.top.equalTo(self.goodsInfoLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(priceWidth, 20));
    }];
    /// 原价
    [self.goodsOriginalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsPriceLabel.mas_right);
        make.top.equalTo(self.goodsPriceLabel).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 14));
    }];
    self.goodsOriginalPriceLabel.text = [NSString stringWithFormat:@"门市价:￥%@", viewModel.goods.originPrice];
}

@end
