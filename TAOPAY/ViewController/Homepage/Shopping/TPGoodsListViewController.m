//
//  TPGoodsListViewController.m
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPGoodsListViewController.h"

#import "TPAppConfig.h"

#import "TPShopGoodsModel.h"

#import "TPShopGoodsListViewModel.h"
#import "TPShopGoodsViewModel.h"
#import "TPGoodsDetailsViewModel.h"

#import "TPShopHomepageCollectionReusableView.h"
#import "TPGoodsCell.h"
#import "YSliderView.h"

#import "TPGoodsDetailsViewController.h"

#import "TPPersonCenterViewController.h"

@interface TPGoodsListViewController ()
@property (nonatomic, strong) TPShopGoodsListViewModel *viewModel;
@property (strong, nonatomic) YSliderView *myCollectionHeaderView;
@end

@implementation TPGoodsListViewController
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configNavigationBar];
    [self setupSubViews];
    
    [self bindViewModel];
}


//MARK: -- config NavigationBar
- (void)configNavigationBar {
    self.navigationView.title = self.viewModel.title;
    self.navigationView.isShowBackButton = YES;
    self.navigationView.isShowNavRightButtons = YES;
    self.navigationView.isShowDownArrowImage = YES;
    [self.view addSubview:self.navigationView];
    
    @weakify(self);
    self.navigationView.clickMeHandler = ^(UIButton *sender) {
        @strongify(self);
        UIStoryboard *toStoryboard = [UIStoryboard storyboardWithName:@"PersonCenter" bundle:nil];
        UIViewController *toController=[toStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([TPPersonCenterViewController class])];
        [self.navigationController pushViewController:toController animated:YES];
    };
    
    self.navigationView.clickHomeHandler = ^(UIButton *sender) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
}

//MARK: -- 初始化子控件
- (void)setupSubViews {
    self.collectionView.frame = CGRectMake(0, NAVGATIONBARHEIGHT, APPWIDTH, APPHEIGHT-NAVGATIONBARHEIGHT);
    
    self.myCollectionHeaderView = [YSliderView instanceSliderView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置headerview,FootView的大小,或者通过下面的代理方法设置
    flowLayout.headerReferenceSize = CGSizeMake(APPWIDTH, TPSHOP_COLLECTION_HEADDERVIEW_HEIGHT);
    
    //注册xib
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TPGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([TPGoodsCell class])];
     [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
}

#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
    @weakify(self);
    [_KVOController y_observe:self.viewModel keyPath:@"catArray" block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        NSArray *tmp = (NSArray *)change[NSKeyValueChangeNewKey];
        if (!YArrayIsEmpty(tmp)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                self.myCollectionHeaderView.dataSource = tmp;
                [self.myCollectionHeaderView layoutIfNeeded];
            });
        }
    }];
}

#pragma mark - Override
//MARK: -- 下拉刷新
- (void)collectionViewDidTriggerHeaderRefresh {
    /// 先调用父类的加载数据
    [super collectionViewDidTriggerHeaderRefresh];
    /// 加载banners data
    @weakify(self);
    [self.viewModel getShopGoodsListSuccess:^(id json) {
        //TODO: --
        @strongify(self);
        [self collectionViewDidFinishTriggerHeader:YES reload:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.collectionView reloadData];
        });
    } failure:^(NSString *error) {
        @strongify(self);
        [self collectionViewDidFinishTriggerHeader:YES reload:NO];
    }];
}

#pragma mark - Override
//MARK: -- UICollectionViewDelegateFlowLayout methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(186, 260);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(APPWIDTH, 306);
}

//设置每个item的UIEdgeInsets
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 2, 0);
//}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}
//MARK: - UIUICollectionViewDataSource Methods
/// config  cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    TPGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TPGoodsCell class]) forIndexPath:indexPath];
    /// 处理事件
    
    return cell;
}

/// config  data
- (void)configureCell:(TPGoodsCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(TPShopGoodsViewModel *)object {
    /// config data (PS：由于MVVM主要是View与数据之间的绑定，但是跟 setViewModel: 差不多啦)
    [cell bindViewModel:object];
}

//设置sectionHeader | sectionFoot
//设置sectionHeader | sectionFoot
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
    headerView.backgroundColor =[UIColor clearColor];
    
    UIImageView *shopBgImageView = UIImageView.new;
    [shopBgImageView setImageWithURL:[NSURL URLWithString:self.viewModel.shopImage] placeholder:nil];
    [headerView addSubview:shopBgImageView];
    [shopBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(APPWIDTH, 265));
    }];
    
    [headerView addSubview:self.myCollectionHeaderView];
    [self.myCollectionHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopBgImageView.mas_bottom);
        make.left.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(APPWIDTH, 38));
    }];
    
    [headerView layoutIfNeeded];
    
    return headerView;
}

//MARK: - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    TPShopGoodsModel *tmpModel = self.viewModel.dataSource[indexPath.row];
    [self pushToGoodsDetailsViewController:tmpModel.goodsID];
    
}

/// 文本内容区域
- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}

#pragma mark - 辅助方法
///MARK: --  跳转界面
- (void)pushToGoodsDetailsViewController:(NSString *)goodsID
{
    TPGoodsDetailsViewModel *viewModel = [[TPGoodsDetailsViewModel alloc] initWithParams:@{YViewModelIDKey:goodsID}];
    TPGoodsDetailsViewController *publicVC = [[TPGoodsDetailsViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:publicVC animated:YES];
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
