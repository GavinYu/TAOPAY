//
//  TPShopListViewController.m
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShopListViewController.h"

#import "TPAppConfig.h"

#import "TPShopModel.h"

#import "TPShopListViewModel.h"
#import "TPShopGoodsListViewModel.h"
#import "TPShopItemViewModel.h"

#import "YSliderView.h"
#import "TPStoreCell.h"

#import "TPGoodsListViewController.h"

@interface TPShopListViewController ()
@property (nonatomic, strong) TPShopListViewModel *viewModel;
@property (strong, nonatomic) YSliderView *myCollectionHeaderView;
@end

@implementation TPShopListViewController
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
    [self requestShopHomepageData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
}

//MARK: -- config NavigationBar
- (void)configNavigationBar {
    self.navigationView.title = TPLocalizedString(@"navigation_title");
    self.navigationView.isShowBackButton = YES;
    self.navigationView.isShowNavRightButtons = YES;
    self.navigationView.isShowDownArrowImage = YES;
    [self.view addSubview:self.navigationView];
}

//MARK: -- 初始化子控件
- (void)setupSubViews {
    self.collectionView.frame = CGRectMake(0, NAVGATIONBARHEIGHT, APPWIDTH, APPHEIGHT-NAVGATIONBARHEIGHT);
    
    self.myCollectionHeaderView = [YSliderView instanceSliderView];
    
    //1.初始化layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置headerview,FootView的大小,或者通过下面的代理方法设置
    flowLayout.headerReferenceSize = CGSizeMake(APPWIDTH, 38);
    
    //注册xib
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TPStoreCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([TPStoreCell class])];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
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
            });
        }
        
    }];
}

//MARK: -- 请求网络数据
//MARK: -- 加载商家列表数据
- (void)requestShopHomepageData {
    @weakify(self);
    
    [[YLocationManager sharedLocationManager] startLocation];
    [[YLocationManager sharedLocationManager] setStartLocationBlock:^(YLocationModel * _Nullable locationDataModel) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            @strongify(self);
            self.viewModel.currentLocationModel = locationDataModel;
            [self collectionViewDidTriggerHeaderRefresh];
        });
    }];
}

#pragma mark - Override
//MARK: -- 下拉刷新
- (void)collectionViewDidTriggerHeaderRefresh {
    if (self.viewModel.currentLocationModel) {
        /// 先调用父类的加载数据
        [super collectionViewDidTriggerHeaderRefresh];
        /// 加载 data
        @weakify(self);
        [self.viewModel getShopListSuccess:^(id json) {
            //TODO: --
            @strongify(self);
            [self collectionViewDidFinishTriggerHeader:YES reload:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.collectionView reloadData];
            });
        } failure:^(NSString *error){
            @strongify(self);
            [self collectionViewDidFinishTriggerHeader:YES reload:NO];
        }];
    }
}

#pragma mark - Override
//MARK: -- UICollectionViewDelegateFlowLayout methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(186, 260);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(APPWIDTH, 38);
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

//MARK: - UICollectionViewDataSource Methods
/// config  cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    TPStoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TPStoreCell class]) forIndexPath:indexPath];
    /// 处理事件
    
    return cell;
}

/// config  data
- (void)configureCell:(TPStoreCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(TPShopListViewModel *)object {
    /// config data (PS：由于MVVM主要是View与数据之间的绑定，但是跟 setViewModel: 差不多啦)
    [cell bindViewModel:object];
}

//设置sectionHeader | sectionFoot
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([DLSlideView class]) forIndexPath:indexPath];
//        return view;
//    } else {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        headerView.backgroundColor =[UIColor clearColor];
    [headerView addSubview:self.myCollectionHeaderView];
        return headerView;
//        return nil;
//    }
}
//MARK: - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    TPShopItemViewModel *tmpViewModel = self.viewModel.dataSource[indexPath.row];
    [self pushToGoodsListViewController:tmpViewModel];
    
}

/// 文本内容区域
- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}

#pragma mark - 辅助方法
///MARK: --  跳转界面
- (void)pushToGoodsListViewController:(TPShopItemViewModel *)shopItemViewModel
{
    TPShopGoodsListViewModel *viewModel = [[TPShopGoodsListViewModel alloc] initWithParams:@{YViewModelIDKey:shopItemViewModel.shopID, YViewModelTitleKey:shopItemViewModel.shopName}];
    TPGoodsListViewController *publicVC = [[TPGoodsListViewController alloc] initWithViewModel:viewModel];
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
