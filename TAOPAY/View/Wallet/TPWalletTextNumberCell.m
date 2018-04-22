//
//  TPWalletTextNumberCell.m
//  TAOPAY
//
//  Created by admin on 2018/4/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPWalletTextNumberCell.h"

#import "TPWalletKeyValueModel.h"

@interface TPWalletTextNumberCell ()
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UIButton *rmbButton;
@property (weak, nonatomic) IBOutlet UIButton *wDollarButton;
@property (weak, nonatomic) IBOutlet UIButton *nDollarButton;
@property (weak, nonatomic) IBOutlet UIButton *dollarButton;

@end

@implementation TPWalletTextNumberCell

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
    
    static NSString *celleIdentifier = @"TPWalletTextNumberCellIdentifier";
    TPWalletTextNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:celleIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TPWalletTextNumberCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)displayCellByDataSources:(nullable id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath{
    [super displayCellByDataSources:dataSources rowAtIndexPath:indexPath];
    
    if (dataSources) {
        TPWalletKeyValueModel *walletKeyValueModel = (TPWalletKeyValueModel *)dataSources;
        _keyLabel.text = walletKeyValueModel.key;
        _valueTextField.text = walletKeyValueModel.value;
        _rmbButton.hidden = !walletKeyValueModel.isHaveImage;
        _wDollarButton.hidden = !walletKeyValueModel.isHaveImage;
        _nDollarButton.hidden = !walletKeyValueModel.isHaveImage;
        _dollarButton.hidden = !walletKeyValueModel.isHaveImage;
    }
}
- (IBAction)clickCellButtons:(UIButton *)sender {
    if (_cellButtonBlock) {
        _cellButtonBlock(sender);
    }
}

@end
