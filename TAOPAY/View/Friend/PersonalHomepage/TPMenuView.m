//
//  TPMenuView.m
//  TAOPAY
//
//  Created by admin on 2018/7/18.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPMenuView.h"

@interface TPMenuView ()
@property (weak, nonatomic) IBOutlet UIButton *momentsButton;
@property (weak, nonatomic) IBOutlet UIButton *mineButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;

@end

@implementation TPMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//MARK: -- instance TPOrderTableHeaderView
+ (TPMenuView *)instanceView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSubViews];
}

- (void)initSubViews {
    
}

- (IBAction)clickMenuEventButton:(UIButton *)sender {
    if (_clickMenuEventBlock) {
        _clickMenuEventBlock(sender);
    }
}

@end
