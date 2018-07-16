//
//  TPAreaListTableHeaderView.m
//  TAOPAY
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPAreaListTableHeaderView.h"

#import "TPAppConfig.h"
#import "YSliderView.h"

#import "TPAreaModel.h"


@interface TPAreaListTableHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *provinceButton;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UIButton *regionButton;
@property (weak, nonatomic) IBOutlet UIView *redLineView;

//@property (strong, nonatomic)  YSliderView *areaSlideView;

@property (strong, nonatomic) UIButton *lastSelectedButton;

@end
@implementation TPAreaListTableHeaderView
{
    FBKVOController *_KVOController;
}

//MARK: -- instance WalletTableHeaderView
+ (TPAreaListTableHeaderView *)instanceAreaListTableHeaderView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configData];
    [self setupSubViews];
}
//MARK: -- Setup subView
- (void)setupSubViews {
//    [self addSubview:self.areaSlideView];
    _lastSelectedButton = _provinceButton;
//    @weakify(self);
//    [self.areaSlideView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(200, self.bounds.size.height));
//    }];
//    self.areaSlideView.dataSource = self.dataArray;
//    self.areaSlideView.clickSliderBlock = ^(UIButton *sender) {
//        @strongify(self);
//        if (self.sliderClickEventBlock) {
//            self.sliderClickEventBlock(self.selectedAreaModel);
//        }
//    };
}

//MARK: -- initData
- (void)configData {
    for (int i = 0; i < 3; ++i) {
        TPAreaModel *itemModel = TPAreaModel.new;
        itemModel.name = @"请选择";
        itemModel.areaID = @"0";
        
        [self.dataArray addObject:itemModel];
    }
}

//MARK: -- 取消按钮事件
- (IBAction)clickCancelButton:(UIButton *)sender {
    if (!_cancelBlock) {
        _cancelBlock(sender);
    }
}
- (IBAction)clickSelectButtons:(UIButton *)sender {
    if (![sender isEqual:_lastSelectedButton]) {
        [UIView animateWithDuration:.3 animations:^{
            [self.redLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(sender);
                make.bottom.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(51, 2));
            }];
            
            [self layoutIfNeeded];
        }];
    }
    
    if (self.sliderClickEventBlock) {
        self.sliderClickEventBlock(self.selectedAreaModel);
    }
    
    _lastSelectedButton = sender;
}

//- (YSliderView *)areaSlideView {
//    if (!_areaSlideView) {
//        _areaSlideView = [YSliderView instanceSliderView];
//    }
//
//    return _areaSlideView;
//}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    
    return _dataArray;
}

- (void)setSelectedAreaModel:(TPAreaModel *)selectedAreaModel {
    if (_selectedAreaModel != selectedAreaModel) {
        _selectedAreaModel = selectedAreaModel;
        
        [_lastSelectedButton setTitle:_selectedAreaModel.name forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
