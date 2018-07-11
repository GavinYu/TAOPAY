//
//  TPGoodsDetailBottomView.m
//  TAOPAY
//
//  Created by admin on 2018/6/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPGoodsDetailBottomView.h"

#import "TPGoodsInfoModel.h"

@interface TPGoodsDetailBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *serviceButton;
@property (weak, nonatomic) IBOutlet UILabel *integralValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralBuyLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;

@end

@implementation TPGoodsDetailBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//MARK: -- instanceGoodsDetailBottomView
+ (TPGoodsDetailBottomView *)instanceGoodsDetailBottomView {
     return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubViews];

}
//MARK: -- config data
//FIXME:TODO: -- 没有积分的值暂时使用价格值
- (void)configData:(TPGoodsInfoModel *)goodsInfo {
    _integralValueLabel.text = [NSString stringWithFormat:@"P%@", goodsInfo.price];
    _priceLabel.text = [NSString stringWithFormat:@"P%@", goodsInfo.price];
    
}
//MARK: -- Setup subView
- (void)setupSubViews {
    [_collectButton setImage:[UIImage imageNamed:@"btn_collect"] forState:UIControlStateNormal];
    //FIXME:TODO: -- 缺少切图
    [_collectButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
}

- (IBAction)clickCollectButton:(UIButton *)sender {
    if (_collectBlock) {
        _collectBlock(sender);
    }
}
- (IBAction)clickServiceButton:(UIButton *)sender {
    if (_serviceBlock) {
        _serviceBlock(sender);
    }
}
- (IBAction)clickIntegralBuyButton:(UIButton *)sender {
    if (_intagralBuyBlock) {
        _intagralBuyBlock(sender);
    }
}
- (IBAction)clickBuyButton:(UIButton *)sender {
    if (_buyBlock) {
        _buyBlock(sender);
    }
}

//MARK: -- setter orea
- (void)setIsCollect:(BOOL)isCollect {
    if (_isCollect != isCollect) {
        _isCollect = isCollect;
        
        [_collectButton setSelected:_isCollect];
    }
}


@end
