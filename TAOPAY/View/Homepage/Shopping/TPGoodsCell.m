//
//  TPGoodsCell.m
//  TAOPAY
//
//  Created by admin on 2018/5/21.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPGoodsCell.h"

#import "TPAppConfig.h"
#import "TPShopGoodsViewModel.h"
#import "TPShopGoodsModel.h"

@interface TPGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *sellNumberLabel;

/// viewModle
@property (nonatomic, readwrite, strong) TPShopGoodsViewModel *viewModel;
@end

@implementation TPGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 以下 MVVM使用的场景，如果使用MVC的请自行ignore
#pragma mark - bind data
- (void)bindViewModel:(TPShopGoodsViewModel *)viewModel {
    self.viewModel = viewModel;
    
    ///商品图片
    [self.goodsImageView setImageWithURL:[NSURL URLWithString:viewModel.goods.image] placeholder:nil];
    /// 商品名称
    self.goodsNameLabel.text = viewModel.goods.name;
    ///已售数量
    self.sellNumberLabel.text = [NSString stringWithFormat:@"已售%@", viewModel.goods.orderCount];
    /// 卖价
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@", viewModel.goods.price];
    /// 星级
    self.starImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",viewModel.goods.star]];
}

@end
