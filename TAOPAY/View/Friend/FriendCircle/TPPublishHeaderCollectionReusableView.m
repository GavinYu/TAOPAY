//
//  TPPublishHeaderCollectionReusableView.m
//  TAOPAY
//
//  Created by admin on 2018/7/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPPublishHeaderCollectionReusableView.h"

#import "TPAppConfig.h"

@interface TPPublishHeaderCollectionReusableView () <YYTextViewDelegate>
@property (strong, nonatomic) YYTextView *addressTextView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (readwrite, copy, nonatomic) NSString *content;
@end

@implementation TPPublishHeaderCollectionReusableView
+ (TPPublishHeaderCollectionReusableView *)instanceView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initSubView];
}

#pragma mark - 初始化视图
- (void)initSubView {
    [self addSubview:self.addressTextView];
    [self.addressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelButton.mas_bottom).offset(10);
        make.left.equalTo(self).offset(29);
        make.size.mas_equalTo(CGSizeMake(APPWIDTH-58, self.bounds.size.height-48));
    }];
}
//MARK: --  取消按钮事件
- (IBAction)clickCancelButton:(UIButton *)sender {
    if (_cancelBlock) {
        _cancelBlock(sender);
    }
}
//MARK: --  提交按钮事件
- (IBAction)clickCommitButton:(UIButton *)sender {
    if (_commitBlock) {
        _commitBlock(self);
    }
}
//MARK: -- YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    if (textView.text.length > 0) {
        self.content = textView.text;
    } else {
        
    }
}

//MARK: -- 懒加载区域
//MARK: -- lazyload addressTextView
- (YYTextView *)addressTextView {
    if (!_addressTextView) {
        _addressTextView = YYTextView.new;
        _addressTextView.backgroundColor = UIColor.clearColor;
        _addressTextView.font = UIFONTSYSTEM(16.0f);
        _addressTextView.placeholderText = @"输入内容...";
        _addressTextView.delegate = self;
    }
    
    return _addressTextView;
}

@end
