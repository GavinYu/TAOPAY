//
//  TPShopHomepageCollectionReusableView.m
//  TAOPAY
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShopHomepageCollectionReusableView.h"

#import "TPAppConfig.h"

#import "YSliderView.h"

#import "TPShopGoodsListViewModel.h"

@interface TPShopHomepageCollectionReusableView ()

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

@end

@implementation TPShopHomepageCollectionReusableView
{
    FBKVOController *_KVOController;
}

+ (TPShopHomepageCollectionReusableView *)instanceShopHomepageCollectionHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubViews];
    
    [self bindViewModel];
}
//MARK: -- config data
- (void)configData {
    self.viewModel = [[TPShopGoodsListViewModel alloc] initWithParams:@{}];
    
}
//MARK: -- Setup subView
- (void)setupSubViews {
    self.sliderView = [YSliderView instanceSliderView];
    [self addSubview:self.sliderView];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(APPWIDTH, 38));
    }];
}


#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
    @weakify(self);
    [_KVOController y_observe:self.viewModel keyPath:@"catArray" block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        NSArray *tmp = change[NSKeyValueChangeNewKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.sliderView.dataSource = tmp;
            [self.sliderView layoutIfNeeded];
            [self layoutIfNeeded];
        });
    }];
}

- (void)setCatArray:(NSArray *)catArray {
    if (_catArray != catArray) {
        _catArray = catArray;
        
        self.sliderView.dataSource = _catArray;
    }
}

@end
