//
//  TPWalletCell.m
//  TAOPAY
//
//  Created by admin on 2018/4/16.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPWalletCell.h"

#import "TPWalletModel.h"

@interface TPWalletCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/// viewModle
@property (nonatomic, readwrite, strong) TPWalletModel *viewModel;

@end

@implementation TPWalletCell

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
    
    static NSString *celleIdentifier = @"TPWalletCellIdentifier";
    TPWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:celleIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TPWalletCell" owner:self options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)displayCellByDataSources:(nullable id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath{
    [super displayCellByDataSources:dataSources rowAtIndexPath:indexPath];
    
    if (dataSources) {
        TPWalletModel *walletModel = (TPWalletModel *)dataSources;
        _iconImageView.image = [UIImage imageNamed:walletModel.icon];
        _contentLabel.text = walletModel.content;
    }
}

@end
