//
//  TPGoodsDetailTableHeaderView.m
//  TAOPAY
//
//  Created by admin on 2018/7/1.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPGoodsDetailTableHeaderView.h"

#import "TPAppConfig.h"

@interface TPGoodsDetailTableHeaderView () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation TPGoodsDetailTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (TPGoodsDetailTableHeaderView *)instanceGoodsDetailTableHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

//MARK: -- Setter imageArray
- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    
    [self configSubView:imageArray];
}

- (void)configSubView:(NSArray *)imageArr {
    self.mainScrollView.contentSize = CGSizeMake(APPWIDTH*imageArr.count, self.mainScrollView.bounds.size.height);
    if (imageArr.count > 0) {
        _numberLabel.text = [NSString stringWithFormat:@"1/%li", imageArr.count];
        for (int i = 0; i < imageArr.count; ++i) {
            UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_mainScrollView.bounds) * i, 0, CGRectGetWidth(_mainScrollView.bounds), CGRectGetHeight(_mainScrollView.bounds))];
            [itemImageView setImageWithURL:[NSURL URLWithString:imageArr[i]] placeholder:nil];
            [_mainScrollView addSubview:itemImageView];
        }
    }
}

//MARK: -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((scrollView.contentOffset.x - pageWidth/ 2) / pageWidth) + 1;
    _numberLabel.text = [NSString stringWithFormat:@"%d/%li", currentPage, self.imageArray.count];
}

@end
