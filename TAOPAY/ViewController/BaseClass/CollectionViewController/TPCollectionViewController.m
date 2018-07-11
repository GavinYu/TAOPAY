//
//  TPCollectionViewController.m
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPCollectionViewController.h"

#import "TPAppConfig.h"
#import "TPCollectionViewModel.h"

@interface TPCollectionViewController ()
/** tableView */
@property (nonatomic, readwrite, weak) UICollectionView *collectionView;
/** contentInset defaul is (64 , 0 , 0 , 0) */
@property (nonatomic, readwrite, assign) UIEdgeInsets contentInset;
/// viewModel
@property (nonatomic, strong, readonly) TPCollectionViewModel *viewModel;
@end

@implementation TPCollectionViewController

@dynamic viewModel;

- (void)dealloc
{
    // set nil
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置子控件
    [self _su_setupSubViews];
    
}

/// setup add `_su_` avoid sub class override it
- (void)_su_setupSubViews
{
    // set up tableView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:MainScreenBounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = self.view.backgroundColor;
    // set delegate and dataSource
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.contentInset  = self.contentInset;
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    /// CoderMikeHe Fixed: 这里需要强制布局一下界面，解决由于设置了tableView的contentInset，然而contentOffset始终是（0，0）的bug
    //    [self.view layoutIfNeeded];
    // 注册cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    /// 添加加载和刷新控件
    if (self.viewModel.shouldPullDownToRefresh) {
        /// 下拉刷新
        @weakify(self);
        [self.collectionView mh_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
            /// 加载下拉刷新的数据
            @strongify(self);
            [self collectionViewDidTriggerHeaderRefresh];
        }];
        [self.collectionView.mj_header beginRefreshing];
    }
    
    if (self.viewModel.shouldPullUpToLoadMore) {
        /// 上拉加载
        @weakify(self);
        [self.collectionView mh_addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
            /// 加载上拉刷新的数据
            @strongify(self);
            [self collectionViewDidTriggerFooterRefresh];
        }];
        
        /// 判断一下数据
        [self collectionViewDidFinishTriggerHeader:NO reload:NO];
    }
    
#ifdef __IPHONE_11_0
    YAdjustsScrollViewInsetNever(self,collectionView);
#endif
}


#pragma mark - sub class override it
/// 下拉事件
- (void)collectionViewDidTriggerHeaderRefresh
{
    self.viewModel.pullDown = YES;
    [self.viewModel loadData:^(id json) {
        /// 默认结束刷新
        [self collectionViewDidFinishTriggerHeader:YES reload:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        /// 默认结束刷新
        [self collectionViewDidFinishTriggerHeader:YES reload:NO];
        
    } configFooter:^(BOOL isLastPage) {
        /// 默认结束刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            self.collectionView.mj_footer.hidden = isLastPage;
        });
    }];
}
/// 上拉事件
- (void)collectionViewDidTriggerFooterRefresh
{
    self.viewModel.pullDown = NO;
    /// 默认结束刷新
    [self.viewModel loadData:^(id json) {
        [self collectionViewDidFinishTriggerHeader:NO reload:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [self collectionViewDidFinishTriggerHeader:NO reload:NO];
    } configFooter:^(BOOL isLastPage) {
        /// 默认结束刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            self.collectionView.mj_footer.hidden = isLastPage;
        });
    }];
}

/// 刷新完成事件
- (void)collectionViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload
{
    __weak TPCollectionViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload) {
            [weakSelf.collectionView reloadData];
        }
        if (isHeader) {
            [weakSelf.collectionView.mj_header endRefreshing];
        }
        else{
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
        /// 最后一页隐藏加载控件
        self.collectionView.mj_footer.hidden = (self.viewModel.page>=self.viewModel.lastPage);
    });
}



/// sub class can override it
- (UIEdgeInsets)contentInset
{
    return UIEdgeInsetsMake(0, 64, 0, 0);
}

/// reload tableView data
- (void)reloadData
{
    [self.collectionView reloadData];
}

/// duqueueReusavleCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

/// configure cell data
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.viewModel.shouldMultiSections) {
        return self.viewModel.dataSource ? self.viewModel.dataSource.count : 1;
    }
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section  {
    if (self.viewModel.shouldMultiSections) {
        return [self.viewModel.dataSource[section] count];
    }
    
    return self.viewModel.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [self collectionView:collectionView dequeueReusableCellWithIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    // fetch object
    id object = nil;
    if (self.viewModel.shouldMultiSections) object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    if (!self.viewModel.shouldMultiSections) object = self.viewModel.dataSource[indexPath.row];
    
    /// bind model
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
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
