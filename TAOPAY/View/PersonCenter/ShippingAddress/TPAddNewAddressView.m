//
//  TPAddNewAddressView.m
//  TAOPAY
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPAddNewAddressView.h"

#import "TPAppConfig.h"
#import "YLocationModel.h"

@interface TPAddNewAddressView () <YYTextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) YYTextView *addressTextView;
@property (strong, nonatomic) UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation TPAddNewAddressView

//MARK: -- instance ShippingAddressTableFooterView
+ (TPAddNewAddressView *)instanceAddNewAddressView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.areaString = @"";
    self.layer.cornerRadius = 2.0;
    [self.layer setMasksToBounds:YES];
    
    [self initSubView];
}

#pragma mark - 初始化视图
- (void)initSubView {
    [self addSubview:self.addressTextView];
    [self.addressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.areaButton.mas_bottom).offset(20);
        make.left.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(APPWIDTH-68, 63));
    }];
}

//MARK: 关闭按钮事件
- (IBAction)clickCloseButton:(UIButton *)sender {
    [self close];
}
//MARK: -- 显示弹窗
- (void)show {
    UIApplication *application = [UIApplication sharedApplication];
    UIWindow *window = application.keyWindow;
    
    self.layer.transform = CATransform3DMakeScale(1.05f, 1.05f, 1.0);
    [window addSubview:self.backView];
    [window addSubview:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.backView addGestureRecognizer:tap];
    
    @weakify(self);
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        @strongify(self);
        self.layer.transform = CATransform3DMakeScale(0.95f, 0.95f, 1.0);
    } completion:^(BOOL finished) {
    }];
}
//MARK: -- 关闭弹窗
- (void)close {
    [self.backView removeFromSuperview];
    [self removeFromSuperview];
}
//MARK: 选择地区按钮事件
- (IBAction)clickSelectAreaButton:(UIButton *)sender {
    [self endEditing:YES];
    
    if (_selectAreaBlock) {
        _selectAreaBlock(sender);
    }
}
//MARK: 保存按钮事件
- (IBAction)clickSaveButton:(UIButton *)sender {
    if (self.nameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入真实姓名"];
        return;
    }
    
    if (self.phoneTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入有效的手机号码"];
        return;
    }
    
    if (self.areaButton.titleLabel.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择地区"];
        return;
    }
    
    @weakify(self);
    [self addShippingAddressSuccess:^(id json) {
        NSString *msg = (NSString *)json;
        [SVProgressHUD showSuccessWithStatus:msg];
        @strongify(self);
        [self close];
        
        if (!self.saveNewAddressBlock) {
            self.saveNewAddressBlock(YES);
        }
        
    } failure:^(NSString *error) {
    }];
}
//MARK: 定位按钮事件
- (IBAction)clickLocationButton:(UIButton *)sender {
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[YLocationManager sharedLocationManager] startLocation];
        [[YLocationManager sharedLocationManager] setStartLocationBlock:^(YLocationModel * _Nullable locationDataModel) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
//                self.addressTextView.text = [NSString stringWithFormat:@"%@%@%@",locationDataModel.currentPlacemark.thoroughfare?:@"",locationDataModel.currentPlacemark.subThoroughfare?:@"",locationDataModel.currentPlacemark.name?:@""];
                self.addressTextView.text = locationDataModel.currentPlacemark.name?:@"";
            });
        }];
    });
}

- (void)textViewDidChange:(YYTextView *)textView {
    if (textView.text.length > 0) {
        self.saveButton.enabled = YES;
        self.saveButton.backgroundColor = TP_BG_RED_COLOR;
    } else {
        self.saveButton.enabled = NO;
        self.saveButton.backgroundColor = UICOLOR_FROM_HEXRGB(0xdfe01e);
    }
}
//MARK: -- 懒加载区域
//MARK: -- lazyload backView
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:MainScreenBounds];
        [_backView setBackgroundColor:[UIColor blackColor]];
        _backView.alpha = 0.5;
    }
    
    return _backView;
}

//MARK: -- lazyload addressTextView
- (YYTextView *)addressTextView {
    if (!_addressTextView) {
        _addressTextView = YYTextView.new;
        _addressTextView.backgroundColor = UIColor.clearColor;
        _addressTextView.placeholderText = @"详细地址（如街道、小区、乡镇、村）";
        _addressTextView.delegate = self;
    }
    
    return _addressTextView;
}

//MARK: -- 请求网络
//新增收货地址接口
- (void)addShippingAddressSuccess:(void(^)(id json))success
                          failure:(void (^)(NSString *error))failure {
    [[YHTTPService sharedInstance] requestAddAddress:self.addressTextView.text name:self.nameTextField.text phone:self.phoneTextField.text areaID:self.selectAreaId success:^(YHTTPResponse *response) {
        if (response.code == YHTTPResponseCodeSuccess) {
            success(response.parsedResult);
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    } failure:^(NSString *msg) {
        failure(msg);
    }];
}

- (void)setSelectAreaId:(NSString *)selectAreaId {
    if (_selectAreaId != selectAreaId) {
        _selectAreaId = selectAreaId;
    }
}

- (void)setAreaString:(NSString *)areaString {
    if (![_areaString isEqualToString:areaString]) {
        _areaString = areaString;
        
        [_areaButton setTitle:_areaString forState:UIControlStateNormal];
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
