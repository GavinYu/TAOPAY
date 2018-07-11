//
//  TPShippingAddressCell.m
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShippingAddressCell.h"

#import "TPAddressModel.h"
#import "TPMacros.h"

@interface TPShippingAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *namePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *setDefaultButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *setTopButton;

@end

@implementation TPShippingAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    [super cellForTableView:tableView];
    
    TPShippingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

//MARK: -- initSubView
- (void)initSubViews {
    [self.setDefaultButton setTitleColor:UICOLOR_FROM_HEXRGB(0x9b9b9b) forState:UIControlStateNormal];
    [self.setDefaultButton setTitleColor:UICOLOR_FROM_HEXRGB(0xabacad) forState:UIControlStateSelected];
}

- (void)displayCellByDataSources:(nullable id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath{
    [super displayCellByDataSources:dataSources rowAtIndexPath:indexPath];
    
    if (dataSources) {
        TPAddressModel *tmpDataModel = (TPAddressModel *)dataSources;
        self.addressModel = tmpDataModel;
        self.namePhoneLabel.text = [NSString stringWithFormat:@"%@, %@", tmpDataModel.name, tmpDataModel.phone];
        self.addressLabel.text = tmpDataModel.address;
        [self.setDefaultButton setSelected:[tmpDataModel.defaultAddress integerValue]==0?YES:NO];
    }
}

//MARK: -- 删除按钮事件
- (IBAction)clickDeleteButton:(UIButton *)sender {
    if (_deleteBlock) {
        _deleteBlock(self.addressModel);
    }
}
//MARK: -- 编辑按钮事件
- (IBAction)clickEditButton:(UIButton *)sender {
    if (_editBlock) {
        _editBlock(self.addressModel);
    }
}
//MARK: -- 置顶按钮事件
- (IBAction)clickSetTopButton:(UIButton *)sender {
    if (_setTopBlock) {
        _setTopBlock(self.addressModel);
    }
}
//MARK: -- 设置默认地址按钮事件
- (IBAction)clickSetDefaultButton:(UIButton *)sender {
    if (_setDefaultBlock) {
        _setDefaultBlock(self.addressModel);
    }
}

@end
