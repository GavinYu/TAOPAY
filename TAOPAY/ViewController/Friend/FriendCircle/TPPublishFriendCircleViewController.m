//
//  TPPublishFriendCircleViewController.m
//  TAOPAY
//
//  Created by admin on 2018/7/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPPublishFriendCircleViewController.h"

#import <QBImagePickerController/QBImagePickerController.h>

#import "TPAppConfig.h"

#import "TPPersonalHomepageTableHeaderView.h"
#import "TPPublishHeaderCollectionReusableView.h"
#import "TPFriendCircleImageCell.h"

#import "TPMenuView.h"


typedef void(^Result)(NSData *fileData, NSString *fileName);

@interface TPPublishFriendCircleViewController () <UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QBImagePickerControllerDelegate>

@property (strong, nonatomic) TPPublishHeaderCollectionReusableView *myCollectionHeaderView;
@property (nonatomic, strong) TPPersonalHomepageTableHeaderView *myTableHeaderView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) UICollectionView *collectionView;

@property (copy, nonatomic) NSString *publishContent;
@property (strong, nonatomic) NSMutableArray *publishFileArray;

@property (nonatomic, strong) TPMenuView *menuView;
@property (assign, nonatomic) BOOL isHaveInitMenuView;

@end

@implementation TPPublishFriendCircleViewController
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDataSource];
    // Do any additional setup after loading the view.
    
    [self setupSubViews];
    [self bindViewModel];
}

//MARK: -- 配置数据
- (void)configDataSource {
    self.dataArray = NSMutableArray.new;
    
    UIImage *addImage = [UIImage imageNamed:@"btn_friend_edit_add"];
    [self.dataArray addObject:addImage];
    
}
//MARK: -- 创建头部视图
- (void)createTableHeaderView {
    self.myTableHeaderView = [TPPersonalHomepageTableHeaderView instanceView];
    self.myTableHeaderView.tableHeaderViewType = TPTableHeaderViewTypeFriendCircle;
    self.myTableHeaderView.frame = CGRectMake(0, 0, APPWIDTH, 180);
    [self.view addSubview:self.myTableHeaderView];
    
    self.myTableHeaderView.userInfoModel = self.currentUserInfoModel;
//    [self.myTableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(APPWIDTH, 180));
//    }];
    
    @weakify(self);
    [self.myTableHeaderView setClickMenuBlock:^(UIButton *sender) {
        @strongify(self);
        if (!self.isHaveInitMenuView) {
            [self createMenuView];
        }
        [self showMenuView:sender.isSelected];
    }];
}

//MARK: -- 创建menu视图
- (void)createMenuView {
    [self.view addSubview:self.menuView];
    
    @weakify(self);
    self.menuView.clickMenuEventBlock = ^(UIButton *sender) {
        @strongify(self);
        //隐藏menuview
        [self showMenuView:NO];
        
        switch (sender.tag) {
            case TPMenuEventTypeMoment:
            {
                
                
            }
                break;
                
            case TPMenuEventTypeMine:
            {
                
            }
                break;
                
            case TPMenuEventTypeSetting:
            {
                
            }
                break;
                
            default:
                break;
        }
    };
    
    self.isHaveInitMenuView = YES;
}

//MARK: -- 显示/隐藏 Menu视图
- (void)showMenuView:(BOOL)isShow {
    @weakify(self);
    
    [UIView animateWithDuration:.3 animations:^{
        @strongify(self);
        if (isShow) {
            self.menuView.frame = CGRectMake(0, self.menuView.frame.origin.y, self.menuView.bounds.size.width, self.menuView.bounds.size.height);
        } else {
            self.menuView.frame = CGRectMake(-self.menuView.bounds.size.width, self.menuView.frame.origin.y, self.menuView.bounds.size.width, self.menuView.bounds.size.height);
        }
    }];
}
//MARK: -- 初始化子控件
- (void)setupSubViews {
    [self createTableHeaderView];
    
    self.myCollectionHeaderView = [TPPublishHeaderCollectionReusableView instanceView];
    
    @weakify(self);
    self.myCollectionHeaderView.cancelBlock = ^(UIButton *sender) {
        @strongify(self);
        if (self.publishFriendCircleCompletionBlock) {
            self.publishFriendCircleCompletionBlock(NO);
        }
    };
    //提交按钮事件
    self.myCollectionHeaderView.commitBlock = ^(TPPublishHeaderCollectionReusableView *sender) {
        @strongify(self);
        [self requestPublishFriendCircle:sender.content];
    };
    //1.初始化layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置headerview,FootView的大小,或者通过下面的代理方法设置
    flowLayout.headerReferenceSize = CGSizeMake(APPWIDTH, 138);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myTableHeaderView.frame), APPWIDTH, APPHEIGHT-CGRectGetMaxY(self.myTableHeaderView.frame)) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    // set delegate and dataSource
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.contentInset  = self.contentInset;
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
    
    //注册xib
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TPFriendCircleImageCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([TPFriendCircleImageCell class])];
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
}

#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section  {
    return self.dataArray.count;
}

#pragma mark - Override
//MARK: -- UICollectionViewDelegateFlowLayout methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(APPWIDTH, 138);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1 || section == 4) {
        return UIEdgeInsetsZero;
    } else {
        return UIEdgeInsetsMake(15, 15, 0, 0);
    }
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

//MARK: - UICollectionViewDataSource Methods
/// config  cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    TPFriendCircleImageCell *cell = [TPFriendCircleImageCell cellForCollectionView:collectionView itemAtIndexPath:indexPath];
    
    if (self.dataArray.count > 0) {
        [cell displayCellByDataSources:self.dataArray[row] itemAtIndexPath:indexPath];
    }
    
    return cell;
}

//设置sectionHeader | sectionFoot
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
    headerView.backgroundColor =[UIColor clearColor];
    [headerView addSubview:self.myCollectionHeaderView];
    
    return headerView;
}
//MARK: - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self showSystemPhoto];
}

//MARK: -- 调取系统相册
- (void)showSystemPhoto {
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 6;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    @weakify(self);
    for (PHAsset *asset in assets) {
        // Do something with the asset
        [self getImageFromPHAsset:asset Complete:^(NSData *fileData, NSString *fileName) {
            @strongify(self);
            if (fileData) {
                [self.dataArray insertObject:fileData atIndex:0];
                [self.collectionView reloadData];
            }
        }];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)getImageFromPHAsset:(PHAsset *)asset Complete:(Result)result {
    __block NSData *data;
    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                          options:options
                                                    resultHandler:
         ^(NSData *imageData,
           NSString *dataUTI,
           UIImageOrientation orientation,
           NSDictionary *info) {
             data = [NSData dataWithData:imageData];
         }];
    }
    
    if (result) {
        if (data.length <= 0) {
            result(nil, nil);
        } else {
            result(data, resource.originalFilename);
        }
    }
}


//MARK: --  UICollectionView 文本内容区域
- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}

#pragma mark - 辅助方法
//MARK: -- 请求网络数据
//MARK: -- 发布朋友圈
- (void)requestPublishFriendCircle:(NSString *)content {
    @weakify(self);
    [[YHTTPService sharedInstance] requestAddFriendArticle:content imageFiles:self.publishFileArray success:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            if (self.publishFriendCircleCompletionBlock) {
                self.publishFriendCircleCompletionBlock(YES);
            }
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
