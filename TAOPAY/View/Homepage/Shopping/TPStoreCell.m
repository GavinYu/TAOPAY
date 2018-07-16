//
//  TPStoreCell.m
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPStoreCell.h"

#import "TPAppConfig.h"
#import "TPShopItemViewModel.h"
#import "TPShopModel.h"

@interface TPStoreCell ()

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *sellNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNumberLabel;

/// viewModle
@property (nonatomic, readwrite, strong) TPShopItemViewModel *viewModel;
@end

@implementation TPStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 以下 MVVM使用的场景，如果使用MVC的请自行ignore
#pragma mark - bind data
- (void)bindViewModel:(TPShopItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    ///商铺图片
    [self.shopImageView setImageWithURL:[NSURL URLWithString:viewModel.shop.image] placeholder:nil];
    ///商铺名称
    self.shopNameLabel.text = viewModel.shop.name;
    ///距离
    self.distanceLabel.text = [self getDistanceString:viewModel.shop.distance];
    ///已售数量
    self.sellNumberLabel.text = [NSString stringWithFormat:@"%@", viewModel.shop.orderCount];
    /// 总量
    self.totalNumberLabel.text = [NSString stringWithFormat:@"共%@件宝贝", viewModel.shop.goodsCount];
    /// 星级
    self.starImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",viewModel.shop.star]];
}

//MARK: -- 将米(m)转换成千米（km）
- (NSString *)getDistanceString:(NSString *)distance {
    CGFloat dis = [distance floatValue];
    CGFloat result = dis / 1000.0;
    return [NSString stringWithFormat:@"%.1fkm", result];
}

@end
