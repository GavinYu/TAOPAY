//
//  TPPersonalHomepageCell.m
//  TAOPAY
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPPersonalHomepageCell.h"

#import "TPAppConfig.h"

#import "TPFriendModel.h"

@interface TPPersonalHomepageCell ()
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *msgNumberButton;

@property (readwrite, copy, nonatomic) NSString *userId;

@end

@implementation TPPersonalHomepageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//MARK: -- 配置子视图
- (void)setupSubView {
    
}

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    [super cellForTableView:tableView];
    
    static NSString *celleIdentifier = @"TPPersonalHomepageCellIdentifier";
    TPPersonalHomepageCell *cell = [tableView dequeueReusableCellWithIdentifier:celleIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)displayCellByDataSources:(nullable id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath{
    [super displayCellByDataSources:dataSources rowAtIndexPath:indexPath];
    
    if (dataSources) {
        TPFriendModel *tmpModel = (TPFriendModel *)dataSources;
        [_avatarButton setImageWithURL:[NSURL URLWithString:tmpModel.avatar] forState:UIControlStateNormal placeholder:nil];
        _nickNameLabel.text = tmpModel.nick;
        _msgLabel.text = tmpModel.info;
        [_msgNumberButton setTitle:tmpModel.count forState:UIControlStateNormal];
        _timeLabel.text = tmpModel.time;
        
        _avatarButton.tag = [tmpModel.userId integerValue];
        self.userId = tmpModel.userId;
    }
}
//MARK: -- 点击头像按钮事件
- (IBAction)clickAvatarButton:(UIButton *)sender {
    if (_avatarTapBlock) {
        _avatarTapBlock(self);
    }
}

@end
