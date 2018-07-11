//
//  TPShoppingTableHeaderView.m
//  TAOPAY
//
//  Created by admin on 2018/5/21.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShoppingTableHeaderView.h"

#import "TPAppConfig.h"
#import "TPShopMainViewModel.h"

@interface TPShoppingTableHeaderView () <SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *tabToolScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *verticalImageView;
@property (weak, nonatomic) IBOutlet UIImageView *horizontalTopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *horizontalBottomImageView;



@end

@implementation TPShoppingTableHeaderView
{
    FBKVOController *_KVOController;
}

+ (TPShoppingTableHeaderView *)instanceShoppingTableHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self configData];
    [self setupSubViews];
    [self bindViewModel];
}
//MARK: -- config data
- (void)configData {
    self.viewModel = [[TPShopMainViewModel alloc] initWithParams:@{}];
    
}
//MARK: -- Setup subView
- (void)setupSubViews {
    self.bannerScrollView.autoScrollTimeInterval = 2.0f;
    self.bannerScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.bannerScrollView.placeholderImage = placeholderImage();
    self.bannerScrollView.delegate = self;
}
//MARK: -- 更新广告活动banner
- (void)updateADImages:(NSArray *)adArray {
    switch (adArray.count) {
        case 1:
        {
            [self.verticalImageView setImageWithURL:[NSURL URLWithString:adArray[0]] placeholder:nil];
        }
            break;
            
        case 2:
        {
            [self.verticalImageView setImageWithURL:[NSURL URLWithString:adArray[0]] placeholder:nil];
            [self.horizontalTopImageView setImageWithURL:[NSURL URLWithString:adArray[1]] placeholder:nil];
        }
            break;
            
        default:
        {
            [self.verticalImageView setImageWithURL:[NSURL URLWithString:adArray[0]] placeholder:nil];
            [self.horizontalTopImageView setImageWithURL:[NSURL URLWithString:adArray[1]] placeholder:nil];
            [self.horizontalBottomImageView setImageWithURL:[NSURL URLWithString:adArray[2]] placeholder:nil];
        }
            break;
    }
}

//MARK: -- SDCycleScrollViewDelegate
//MARK: -- /** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (_clickBannerBlock) {
        _clickBannerBlock(index);
    }
    
}

#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
//    _KVOController = [[FBKVOController alloc] initWithObserver:self];
    _KVOController = [FBKVOController controllerWithObserver:self];
    @weakify(self);
//    [_KVOController observe:self.viewModel keyPath:@"bannerData" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionPrior block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
//        @strongify(self);
//        NSArray *tmp = (NSArray *)change[NSKeyValueChangeNewKey];
//        if (!YArrayIsEmpty(tmp)) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                @strongify(self);
//                self.bannerScrollView.imageURLStringsGroup = tmp;
//            });
//        }
//    }];
    [_KVOController y_observe:self.viewModel keyPath:@"bannerData" block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        NSArray *tmp = (NSArray *)change[NSKeyValueChangeNewKey];
        if (!YArrayIsEmpty(tmp)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                self.bannerScrollView.imageURLStringsGroup = tmp;
            });
        }
    }];
    
    [_KVOController y_observe:self.viewModel keyPath:@"adData" block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        NSArray *tmp = (NSArray *)change[NSKeyValueChangeNewKey];
        if (!YArrayIsEmpty(tmp)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self updateADImages:tmp];
            });
        }
        
    }];
    
}

- (void)setBannerArray:(NSArray *)bannerArray {
    _bannerArray = bannerArray;
    
    self.bannerScrollView.imageURLStringsGroup = _bannerArray;
}

- (void)setAdsArray:(NSArray *)adsArray {
    _adsArray = adsArray;
    
    [self updateADImages:_adsArray];
}

//MARK: -- TabToolView buttons event
- (IBAction)clickTabToolButtons:(UIButton *)sender {
    if (_clickToolBlock) {
        _clickToolBlock(sender.tag);
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
