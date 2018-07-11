//
//  TPGoodsDetailInfoCell.m
//  TAOPAY
//
//  Created by admin on 2018/7/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPGoodsDetailInfoCell.h"

#import "TPGoodsInfoModel.h"
#import "TPAppConfig.h"

@interface TPGoodsDetailInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;

@end

@implementation TPGoodsDetailInfoCell

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
    
    static NSString *celleIdentifier = @"TPGoodsDetailInfoCellIdentifier";
    TPGoodsDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:celleIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TPGoodsDetailInfoCell" owner:self options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)displayCellByDataSources:(nullable id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath{
    [super displayCellByDataSources:dataSources rowAtIndexPath:indexPath];
    
    if (dataSources) {
        TPGoodsInfoModel *infoModel = (TPGoodsInfoModel *)dataSources;
        [_infoImageView setImageWithURL:[NSURL URLWithString:infoModel.image] placeholder:nil];
    }
}

@end
