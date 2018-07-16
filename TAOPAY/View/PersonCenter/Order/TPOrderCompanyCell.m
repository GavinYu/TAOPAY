//
//  TPOrderCompanyCell.m
//  TAOPAY
//
//  Created by admin on 2018/7/15.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderCompanyCell.h"

#import "TPAppConfig.h"

#import "TPOrderModel.h"
#import "TPCompanyModel.h"

@interface TPOrderCompanyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;

@end

@implementation TPOrderCompanyCell

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
    
    static NSString *celleIdentifier = @"TPOrderCompanyCellIdentifier";
    TPOrderCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:celleIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)displayCellByDataSources:(nullable id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath{
    [super displayCellByDataSources:dataSources rowAtIndexPath:indexPath];
    
    if (dataSources) {
        TPCompanyModel *tmpCompanyModel = (TPCompanyModel *)dataSources;
        //FIXME:TODO -- 商户的logo还没数据
//        [_logoImageView setImageWithURL:[NSURL URLWithString:@""] placeholder:nil];
        _shopNameLabel.text = tmpCompanyModel.name;
        
        CGFloat nameWidth = [YUtil getTextWidthWithContent:_shopNameLabel.text withContentSizeOfHeight:_shopNameLabel.bounds.size.height withAttribute:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}] + 5;
        
        [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImageView.mas_right).offset(5);
            make.centerY.equalTo(self.logoImageView);
            make.size.mas_equalTo(CGSizeMake(nameWidth, self.shopNameLabel.bounds.size.height));
        }];
        
        [_rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.shopNameLabel.mas_right).offset(5);
            make.centerY.equalTo(self.shopNameLabel);
            make.size.mas_equalTo(self.rightArrowImageView.bounds.size);
        }];
    }
}

//MARK: -- Setter orderStatus
- (void)setOrderStatus:(NSString *)orderStatus {
    if (_orderStatus != orderStatus) {
        _orderStatus = orderStatus;
        
        _orderStatusLabel.text = _orderStatus;
    }
}

@end
