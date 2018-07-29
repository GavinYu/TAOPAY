//
//  TPFriendCell.m
//  TAOPAY
//
//  Created by admin on 2018/5/6.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPFriendCell.h"

#import "TPAddressBookModel.h"
#import "TPAppConfig.h"

@interface TPFriendCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;

@property (readwrite, copy, nonatomic) NSString *phoneNumber;

@end

@implementation TPFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

//MARK: -- 配置子视图
- (void)setupSubView {
    self.phoneNumber = @"";
    
    [_attentionButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_attention_normal"] forState:UIControlStateNormal];
    [_attentionButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_attention_highlight"] forState:UIControlStateHighlighted];
    [self addActionDealForMVCOrMVVMWithoutRAC];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    [super cellForTableView:tableView];
    
    static NSString *celleIdentifier = @"TPFriendCellIdentifier";
    TPFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:celleIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TPFriendCell" owner:self options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)displayCellByDataSources:(nullable id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath{
    [super displayCellByDataSources:dataSources rowAtIndexPath:indexPath];
    
    if (dataSources) {
        TPAddressBookModel *itemModel = (TPAddressBookModel *)dataSources;
        _avatarImageView.image = [UIImage imageWithData:itemModel.avatar];
        _nameLabel.text = itemModel.name;
        self.phoneNumber = itemModel.phone;
    }
}

#pragma mark - 事件处理
//// 以下 MVC 和 MVVM without RAC 的事件回调的使用的场景，如果使用MVVM With RAC的请自行ignore
/// 事件处理 我这里使用 block 来回调事件 （PS：大家可以自行决定）
- (void)addActionDealForMVCOrMVVMWithoutRAC {
     @weakify(self);
    /// 位置被点击
    [self.attentionButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        !self.attentionClickedHandler?:self.attentionClickedHandler(self);
    } forControlEvents:UIControlEventTouchUpInside];
}

@end
