//
//  TPGoodsDetailsCell.m
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPGoodsDetailsCell.h"

#import "TPGoodsInfoModel.h"
#import "TPAppConfig.h"

@interface TPGoodsDetailsCell ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation TPGoodsDetailsCell

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
    
    static NSString *celleIdentifier = @"TPGoodsDetailsCellIdentifier";
    TPGoodsDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:celleIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TPGoodsDetailsCell" owner:self options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)displayCellByDataSources:(nullable id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath{
    [super displayCellByDataSources:dataSources rowAtIndexPath:indexPath];
    
    if (dataSources) {
        TPGoodsInfoModel *infoModel = (TPGoodsInfoModel *)dataSources;
        _titleLabel.text = infoModel.name;
        _infoLabel.text = infoModel.sinfo;
        _priceLabel.text = [NSString stringWithFormat:@"￥%@", infoModel.price];
        CGFloat priceWidth = [YUtil getTextWidthWithContent:_priceLabel.text withContentSizeOfHeight:_priceLabel.bounds.size.height withAttribute:@{NSFontAttributeName:_priceLabel.font}];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(11);
            make.size.mas_equalTo(CGSizeMake(priceWidth, 20));
        }];
        /// 原价
        [_originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceLabel.mas_right);
            make.top.equalTo(self.priceLabel).offset(5);
            make.size.mas_equalTo(CGSizeMake(100, 14));
        }];
        _originPriceLabel.text = [NSString stringWithFormat:@"￥%@", infoModel.originPrice];
    }
}

- (IBAction)clickMoreButton:(UIButton *)sender {
}

@end
