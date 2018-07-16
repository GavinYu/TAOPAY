//
//  TPOrderGoodsCell.m
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderGoodsCell.h"

#import "TPAppConfig.h"

#import "TPOrderGoodsModel.h"
#import "TPOrderModel.h"

@interface TPOrderGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@end

@implementation TPOrderGoodsCell

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
    
    static NSString *celleIdentifier = @"TPOrderGoodsCellIdentifier";
    TPOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:celleIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)displayCellByDataSources:(nullable id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath{
    [super displayCellByDataSources:dataSources rowAtIndexPath:indexPath];
    
    if (dataSources) {
        TPOrderGoodsModel *tmpModel = (TPOrderGoodsModel *)dataSources;
        [_goodsImageView setImageWithURL:[NSURL URLWithString:tmpModel.image] placeholder:nil];
        _goodsNameLabel.text = tmpModel.name;
        _goodsCountLabel.text =  [NSString stringWithFormat:@"x%@",tmpModel.count];
        _goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@",tmpModel.price];
        _markLabel.text = [NSString getStringFromString:tmpModel.info];
    }
}

@end
