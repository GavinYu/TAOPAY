//
//  TPAreaListTableHeaderView.m
//  TAOPAY
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPAreaListTableHeaderView.h"

#import "TPAppConfig.h"
#import "DLSlideView.h"

@interface TPAreaListTableHeaderView () <DLSlideViewDelegate,DLSlideViewDataSource>

@property (weak, nonatomic) IBOutlet DLSlideView *areaSlideView;

@end
@implementation TPAreaListTableHeaderView
{
    FBKVOController *_KVOController;
}

//MARK: -- instance WalletTableHeaderView
+ (TPAreaListTableHeaderView *)instanceAreaListTableHeaderView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"TPWalletTableHeaderView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubViews];
}
//MARK: -- Setup subView
- (void)setupSubViews {
    self.areaSlideView.delegate = self;
    self.areaSlideView.dataSource = self;
}

//MARK: -- 取消按钮事件
- (IBAction)clickCancelButton:(UIButton *)sender {
    if (!_cancelBlock) {
        _cancelBlock(sender);
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
