//
//  YSliderView.m
//  TAOPAY
//
//  Created by admin on 2018/7/8.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YSliderView.h"

#import "TPMacros.h"

#import "TPGoodsCategoryModel.h"
#import "TPAreaModel.h"

#import <Masonry/Masonry.h>

#define YMoiety 8
#define YMoietyWidth  APPWIDTH/YMoiety

@interface YSliderView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *sliderScrollView;
@property (strong, nonatomic) UIButton *lastSelectedButton;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation YSliderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//MARK: -- instanceSliderView
+ (YSliderView *)instanceSliderView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)setDataSource:(NSArray *)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        
        NSInteger m = dataSource.count % YMoiety;
        NSInteger n = dataSource.count / YMoiety;
        
        _sliderScrollView.contentSize = CGSizeMake(APPWIDTH * m + YMoietyWidth * n, CGRectGetHeight(_sliderScrollView.bounds));
        
        if (_dataSource.count > 0) {
            for (int i = 0; i < dataSource.count; ++i) {
                UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                itemBtn.frame = CGRectMake(YMoietyWidth * i, 0, YMoietyWidth, CGRectGetHeight(_sliderScrollView.bounds));
                itemBtn.titleLabel.font = self.titleFont?:[UIFont systemFontOfSize:16.0];
                [itemBtn setTitleColor:TP_BG_RED_COLOR forState:UIControlStateSelected];
                [itemBtn setTitleColor:TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1 forState:UIControlStateNormal];
                [itemBtn addTarget:self action:@selector(clickItemButton:) forControlEvents:UIControlEventTouchUpInside];
                //分情况
                id tmpObj = dataSource[i];
                if ([tmpObj isKindOfClass:[TPGoodsCategoryModel class]]) {
                    //产品分类
                    
                    TPGoodsCategoryModel *tmpModel = (TPGoodsCategoryModel *)tmpObj;
                    [itemBtn setTitle:tmpModel.name forState:UIControlStateNormal];
                    itemBtn.tag = [tmpModel.categoryID integerValue];
                } else if ([tmpObj isKindOfClass:[TPAreaModel class]]){
                    //省、市、区/县
                    
                    TPAreaModel *tmpModel = (TPAreaModel *)tmpObj;
                    [itemBtn setTitle:tmpModel.name forState:UIControlStateNormal];
                    itemBtn.tag = [tmpModel.areaID integerValue];
                }
                
                [_sliderScrollView addSubview:itemBtn];
                
                if (i == 0) {
                    [itemBtn setSelected:!itemBtn.isSelected];
                    _lastSelectedButton = itemBtn;
                }
            }
            
            [self addSubview:self.lineView];
            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.lastSelectedButton).offset(1);
                make.centerX.equalTo(self.lastSelectedButton);
                make.size.mas_equalTo(CGSizeMake(30, 2));
            }];
            
            [self layoutIfNeeded];
        }
    }
}
//MARK: -- Slider 按钮事件
- (void)clickItemButton:(UIButton *)sender {
    [UIView animateWithDuration:.3 animations:^{
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(sender).offset(1);
            make.centerX.equalTo(sender);
            make.size.mas_equalTo(CGSizeMake(30, 2));
        }];
        [self.lastSelectedButton setSelected:NO];
        [sender setSelected:!sender.isSelected];
        self.lastSelectedButton = sender;
    }];

    if (_clickSliderBlock) {
        _clickSliderBlock(sender);
    }
}

- (void)reloadSliderView {
    
}

- (void)setTitleFont:(UIFont *)titleFont {
    if (_titleFont != titleFont) {
        _titleFont = titleFont;
    }
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = TP_BG_RED_COLOR;
    }
    
    return _lineView;
}

@end
