//
//  TPShoppingPayGoodsCell.m
//  TAOPAY
//
//  Created by admin on 2018/7/5.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShoppingPayGoodsCell.h"

#import "TPShoppingCartGoodsModel.h"
#import "TPAppConfig.h"

@interface TPShoppingPayGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;

@end

@implementation TPShoppingPayGoodsCell

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
    
    static NSString *celleIdentifier = @"TPShoppingPayGoodsCellIdentifier";
    TPShoppingPayGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:celleIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)displayCellByDataSources:(nullable id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath{
    [super displayCellByDataSources:dataSources rowAtIndexPath:indexPath];
    
    if (dataSources) {
        TPShoppingCartGoodsModel *tmpModel = (TPShoppingCartGoodsModel *)dataSources;
        [_goodsImageView setImageWithURL:[NSURL URLWithString:tmpModel.image] placeholder:nil];
        _goodsNameLabel.text = tmpModel.name;
        _goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@/件", tmpModel.price];
    }
}

@end
