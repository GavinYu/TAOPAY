//
//  TPWalletCommonCell.m
//  TAOPAY
//
//  Created by admin on 2018/4/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPWalletCommonCell.h"

#import "TPWalletCommonModel.h"
#import "TPCardOperateViewModel.h"

@interface TPWalletCommonCell ()

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation TPWalletCommonCell

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
    
    static NSString *celleIdentifier = @"TPWalletCommonCellIdentifier";
    TPWalletCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:celleIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TPWalletCommonCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)displayCellByDataSources:(nullable id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath{
    [super displayCellByDataSources:dataSources rowAtIndexPath:indexPath];
    
    if (dataSources) {
        TPWalletCommonModel *walletCommonModel = (TPWalletCommonModel *)dataSources;
        _mainTitleLabel.text = walletCommonModel.mainTitle;
        _subTitleLabel.text = walletCommonModel.subTitle;
        [_iconImageView setImage:[UIImage imageNamed:walletCommonModel.icon]];
    }
}

@end
