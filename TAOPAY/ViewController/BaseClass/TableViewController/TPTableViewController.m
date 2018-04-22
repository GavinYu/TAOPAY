//
//  TPTableViewController.m
//  TAOPAY
//
//  Created by admin on 2018/4/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTableViewController.h"

#import "TPAppConfig.h"

@interface TPTableViewController ()
/** tableView */
@property (nonatomic, readwrite, weak) UITableView *tableView;
/** contentInset defaul is (64 , 0 , 0 , 0) */
@property (nonatomic, readwrite, assign) UIEdgeInsets contentInset;
/// viewModel
@property (nonatomic, strong, readonly) TPTableViewModel *viewModel;
@end

@implementation TPTableViewController
@dynamic viewModel;

- (void)dealloc
{
    // set nil
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:MainScreenBounds style:self.viewModel.style];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // set delegate and dataSource
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset  = self.contentInset;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    /// CoderMikeHe Fixed: 这里需要强制布局一下界面，解决由于设置了tableView的contentInset，然而contentOffset始终是（0，0）的bug
    //    [self.view layoutIfNeeded];
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    /// 添加加载和刷新控件
    if (self.viewModel.shouldPullDownToRefresh) {
        /// 下拉刷新
        @weakify(self);
        [self.tableView mh_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
            /// 加载下拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerHeaderRefresh];
        }];
        [self.tableView.mj_header beginRefreshing];
    }
    
    if (self.viewModel.shouldPullUpToLoadMore) {
        /// 上拉加载
        @weakify(self);
        [self.tableView mh_addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
            /// 加载上拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerFooterRefresh];
        }];
        
        /// 判断一下数据
        [self tableViewDidFinishTriggerHeader:NO reload:NO];
    }
    
#ifdef __IPHONE_11_0
    YAdjustsScrollViewInsetNever(self,tableView);
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
#endif
}


#pragma mark - sub class override it
/// 下拉事件
- (void)tableViewDidTriggerHeaderRefresh
{
    self.viewModel.pullDown = YES;
    [self.viewModel loadData:^(id json) {
        /// 默认结束刷新
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        /// 默认结束刷新
        [self tableViewDidFinishTriggerHeader:YES reload:NO];
        
    } configFooter:^(BOOL isLastPage) {
        /// 默认结束刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.mj_footer.hidden = isLastPage;
        });
    }];
}
/// 上拉事件
- (void)tableViewDidTriggerFooterRefresh
{
    self.viewModel.pullDown = NO;
    /// 默认结束刷新
    [self.viewModel loadData:^(id json) {
        [self tableViewDidFinishTriggerHeader:NO reload:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [self tableViewDidFinishTriggerHeader:NO reload:NO];
    } configFooter:^(BOOL isLastPage) {
        /// 默认结束刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.mj_footer.hidden = isLastPage;
        });
    }];
}

/// 刷新完成事件
- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload
{
    __weak TPTableViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload) {
            [weakSelf.tableView reloadData];
        }
        if (isHeader) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        /// 最后一页隐藏加载控件
        self.tableView.mj_footer.hidden = (self.viewModel.page>=self.viewModel.lastPage);
    });
}



/// sub class can override it
- (UIEdgeInsets)contentInset
{
    return UIEdgeInsetsMake(64, 0, 0, 0);
}

/// reload tableView data
- (void)reloadData
{
    [self.tableView reloadData];
}

/// duqueueReusavleCell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

/// configure cell data
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.viewModel.shouldMultiSections) return self.viewModel.dataSource ? self.viewModel.dataSource.count : 1;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.viewModel.shouldMultiSections) return [self.viewModel.dataSource[section] count];
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // fetch object
    id object = nil;
    if (self.viewModel.shouldMultiSections) object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    if (!self.viewModel.shouldMultiSections) object = self.viewModel.dataSource[indexPath.row];
    
    /// bind model
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    
    return cell;
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
