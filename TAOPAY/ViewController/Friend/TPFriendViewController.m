//
//  TPFriendViewController.m
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPFriendViewController.h"

#import "TPAppConfig.h"
#import "TPFriendViewModel.h"
#import "TPFriendCell.h"

@interface TPFriendViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TPFriendViewModel *viewModel;

@end

@implementation TPFriendViewController
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view bringSubviewToFront:self.navigationView];
    self.navigationView.title = @"好友";
    
    [self setupSubViews];
    // bind viewModel
    [self bindViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: -- lazyload
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

#pragma mark - 初始化子控件
- (void)setupSubViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(APPWIDTH, APPHEIGHT-TPTABBARHEIGHT));
    }];
    //tableView 注册cell 和 headerview
    [self.tableView y_registerNibCell:[TPFriendCell class]];
}

#pragma mark - BindModel
- (void)bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
}
#pragma mark - Override
//MARK: - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataArray.count;
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    TPFriendCell *cell = [TPFriendCell cellForTableView:tableView];
    
//    if (self.dataArray.count > 0) {
//        [cell displayCellByDataSources:self.dataArray[row] rowAtIndexPath:indexPath];
//    }
    
    ///关注按钮事件
    @weakify(self);
    cell.attentionClickedHandler = ^(TPFriendCell *friendCell) {
        @strongify(self);
        
    };
    
    return cell;
}

//MARK: -- UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
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
