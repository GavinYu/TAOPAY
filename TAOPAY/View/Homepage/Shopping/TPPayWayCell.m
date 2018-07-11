//
//  TPPayWayCell.m
//  TAOPAY
//
//  Created by admin on 2018/7/7.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPPayWayCell.h"

#import "TPAppConfig.h"
#import "TPWalletModel.h"

@interface TPPayWayCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end

@implementation TPPayWayCell

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
    
    static NSString *celleIdentifier = @"TPPayWayCellIdentifier";
    TPPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:celleIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)displayCellByDataSources:(nullable id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath{
    [super displayCellByDataSources:dataSources rowAtIndexPath:indexPath];
    
    if (dataSources) {
        TPWalletModel *tmpModel = (TPWalletModel *)dataSources;
        _iconImageView.image = [UIImage imageNamed:tmpModel.icon];
        _titleLabel.text = tmpModel.content;
        _markLabel.text = [self getMarkTextWithPayType:(TPPayType)[tmpModel.type integerValue]];
    }
}

//MARK: -- get MarkText
- (NSString *)getMarkTextWithPayType:(TPPayType)payType {
    NSString *tmpText = @"";
    switch (payType) {
        case TPPayTypeVIP:
        case TPPayTypeWeChat:
        {
            tmpText = @"(推荐)";
        }
            break;
            
        case TPPayTypeAlipay:
        {
            tmpText = @"(50元内免密支付)";
        }
            break;
            
        default:
            break;
    }
    
    return tmpText;
}
//MARK: -- Setter area
//MARK: -- Setter isVIP
- (void)setIsVIP:(BOOL)isVIP {
    _isVIP = isVIP;
    _markLabel.font = isVIP?UIFONTSYSTEM(16):UIFONTSYSTEM(12);
}
//MARK: -- Setter isSelect
- (void)setIsSelect:(BOOL)isSelect {
    if (_isSelect != isSelect) {
        _isSelect = isSelect;
        _checkImageView.hidden = !isSelect;
    }
}

@end
