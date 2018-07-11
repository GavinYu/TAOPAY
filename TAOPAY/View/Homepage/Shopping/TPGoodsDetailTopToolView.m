//
//  TPGoodsDetailTopToolView.m
//  TAOPAY
//
//  Created by admin on 2018/6/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPGoodsDetailTopToolView.h"

@interface TPGoodsDetailTopToolView ()

@end

@implementation TPGoodsDetailTopToolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (TPGoodsDetailTopToolView *)instanceGoodsDetailTopToolView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (IBAction)clickBackButton:(UIButton *)sender {
    if (_clickBackBlock) {
        _clickBackBlock(sender);
    }
}
- (IBAction)clickShareButton:(UIButton *)sender {
    if (_clickShareBlock) {
        _clickShareBlock(sender);
    }
}
@end
