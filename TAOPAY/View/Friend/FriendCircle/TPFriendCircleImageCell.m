//
//  TPFriendCircleImageCell.m
//  TAOPAY
//
//  Created by admin on 2018/7/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPFriendCircleImageCell.h"

#import "TPAppConfig.h"

@interface TPFriendCircleImageCell ()
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@end

@implementation TPFriendCircleImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)indexPath
{
    [super cellForCollectionView:collectionView itemAtIndexPath:indexPath];

    TPFriendCircleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (void)displayCellByDataSources:(id)dataSources itemAtIndexPath:(NSIndexPath *)indexPath {
    [super displayCellByDataSources:dataSources itemAtIndexPath:indexPath];
    if (dataSources) {
        if ([dataSources isKindOfClass:[UIImage class]]) {
            [_addButton setImage:dataSources forState:UIControlStateNormal];
            _addButton.userInteractionEnabled = NO;
        } else if ([dataSources isKindOfClass:[NSData class]]) {
            [_addButton setImage:[UIImage imageWithData:dataSources] forState:UIControlStateNormal];
            _addButton.userInteractionEnabled = NO;
        } else {
            //FIXME:TODO -- 后面看看对应哪个字段
            [_addButton setImageWithURL:[NSURL URLWithString:dataSources] forState:UIControlStateNormal placeholder:nil];
        }
        
    }
}

//MARK: -- 添加按钮事件
- (IBAction)clickAddButton:(UIButton *)sender {
    if (_addImageBlock) {
        _addImageBlock(self);
    }
}

//MARK: -- Setter area
//MARK: -- Setter
- (void)setAddButtonEnable:(BOOL)addButtonEnable {
    if (_addButtonEnable != addButtonEnable) {
        _addButtonEnable = addButtonEnable;
        
        _addButton.userInteractionEnabled = _addButtonEnable;
    }
}
@end
