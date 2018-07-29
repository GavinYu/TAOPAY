//
//  TPChatMsgListCell.m
//  TAOPAY
//
//  Created by admin on 2018/7/25.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPChatMsgListCell.h"

#import "TPAppConfig.h"

#import "TPUserInfoModel.h"

@interface TPChatMsgListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *msgCountLabel;

@end

@implementation TPChatMsgListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//MARK: -- 配置子视图
- (void)setupSubViews {
    self.avatarImageView.layer.cornerRadius = 5;
    self.avatarImageView.layer.masksToBounds = YES;
    
    self.msgCountLabel.layer.cornerRadius = 2.5;
    self.msgCountLabel.layer.masksToBounds = YES;
}

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    [super cellForTableView:tableView];
    
    static NSString *celleIdentifier = @"TPChatMsgListCellIdentifier";
    TPChatMsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:celleIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)displayCellByDataSources:(nullable id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath{
    [super displayCellByDataSources:dataSources rowAtIndexPath:indexPath];
    
    if (dataSources) {
        TPUserInfoModel *tmpModel = (TPUserInfoModel *)dataSources;
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:tmpModel.avatar] placeholder:nil];
    }
}

- (void)setMessageCount:(NSString *)messageCount {
    if (!messageCount) {
        _messageCount = nil;
        self.msgCountLabel.text = @"";
        
        self.msgCountLabel.hidden = YES;
    } else {
        self.msgCountLabel.hidden = NO;
        
        if (_messageCount != messageCount) {
            _messageCount = messageCount;
            
            self.msgCountLabel.text = messageCount;
        }
    }
}

@end
