//
//  FriendCircleCell.m
//  TAOPAY
//
//  Created by admin on 2018/7/19.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "FriendCircleCell.h"

#import "TPAppConfig.h"

#import "TPFriendCircleItemViewModel.h"

#import "TPFriendArticleModel.h"

#import "TPFriendCircleImageCell.h"

@interface FriendCircleCell ()
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/// viewModle
@property (readwrite, strong,nonatomic) TPFriendCircleItemViewModel *viewModel;

@property (strong, nonatomic) NSMutableArray *imageDataSource;

@end

@implementation FriendCircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initSubViews];
    [self _addActionDealForMVCOrMVVMWithoutRAC];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//MARK: -- initSubViews
- (void)initSubViews {
    
    //注册xib
    [self.imageCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TPFriendCircleImageCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([TPFriendCircleImageCell class])];
}
// 以下 MVVM使用的场景，如果使用MVC的请自行ignore
#pragma mark - bind data
- (void)bindViewModel:(TPFriendCircleItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    ///商品图片
    [self.avatarButton setImageWithURL:[NSURL URLWithString:viewModel.friendArticleModel.avatar] forState:UIControlStateNormal placeholder:nil];
    self.nameLabel.text = viewModel.friendArticleModel.nick;
    self.contentLabel.text = viewModel.friendArticleModel.content;
    self.timeLabel.text = viewModel.friendArticleModel.time;
    
    if (self.imageDataSource.count > 0) {
        [self.imageDataSource removeAllObjects];
        self.imageDataSource = nil;
    }
    self.imageDataSource = [[NSMutableArray alloc] initWithCapacity:viewModel.friendArticleModel.files.count];
    [self.imageDataSource addObjectsFromArray:viewModel.friendArticleModel.files];
    [self.imageCollectionView reloadData];
}

#pragma mark - 事件处理
//// 以下 MVC 和 MVVM without RAC 的事件回调的使用的场景，如果使用MVVM With RAC的请自行ignore
/// 事件处理 我这里使用 block 来回调事件
- (void)_addActionDealForMVCOrMVVMWithoutRAC{
    //头像被点击
    @weakify(self);
    [self.avatarButton bk_addEventHandler:^(id sender) {
        @strongify(self);
    } forControlEvents:UIControlEventTouchUpInside];
    
}

//MARK: -- UITextFieldDelegate
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section  {
    return self.imageDataSource.count;
}

#pragma mark - Override
//MARK: -- UICollectionViewDelegateFlowLayout methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(74, 74);
}

//设置每个item的UIEdgeInsets
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 2, 0);
//}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 7;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 7;
}

//MARK: - UICollectionViewDataSource Methods
/// config  cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    TPFriendCircleImageCell *cell = [TPFriendCircleImageCell cellForCollectionView:collectionView itemAtIndexPath:indexPath];
    cell.userInteractionEnabled = NO;
    if (self.imageDataSource.count > 0) {
        [cell displayCellByDataSources:self.imageDataSource[row] itemAtIndexPath:indexPath];
    }
    
    return cell;
}

//MARK: - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

@end
