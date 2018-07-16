//
//  TPAreaListView.m
//  TAOPAY
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPAreaListView.h"

#import "TPAppConfig.h"
#import "TPAreaListTableHeaderView.h"
#import "TPAreaListModel.h"
#import "TPAreaModel.h"

@interface TPAreaListView () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) TPAreaListTableHeaderView *myTableHeaderView;
@property (strong, nonatomic) UIView *backView;
@property (copy, nonatomic) NSString *areaID;
@property (strong, nonatomic) TPAreaListModel *areaListModel;

@end

@implementation TPAreaListView
//MARK: -- instance ShippingAddressTableFooterView
+ (TPAreaListView *)instanceAreaListView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initSubView];
}

#pragma mark - 初始化视图
- (void)initSubView {
    self.areaID = @"0";
    self.myTableView.tableHeaderView = self.myTableHeaderView;
    
    @weakify(self);
    self.myTableHeaderView.sliderClickEventBlock = ^(TPAreaModel *areaModel) {
        //FIXME: TODO --
        @strongify(self);
        self.areaID = areaModel.areaID;
        [self requestAreaListData];
    };
    [self requestAreaListData];
}

//MARK: 关闭按钮事件
- (IBAction)clickCloseButton:(UIButton *)sender {
    [self close];
}
//MARK: -- 显示弹窗
- (void)show {
    UIApplication *application = [UIApplication sharedApplication];
    UIWindow *window = application.keyWindow;
    
    self.layer.transform = CATransform3DMakeScale(1.05f, 1.05f, 1.0);
    [window addSubview:self.backView];
    [window addSubview:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.backView addGestureRecognizer:tap];
    
    @weakify(self);
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        @strongify(self);
        self.layer.transform = CATransform3DMakeScale(0.95f, 0.95f, 1.0);
    } completion:^(BOOL finished) {
    }];
}
//MARK: -- 关闭弹窗
- (void)close {
    [self.backView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - Override
//MARK: - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.areaListModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    static NSString *CellInentifier = @"UITabeViewCellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellInentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellInentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = UIFONTSYSTEM(14.0);
        cell.textLabel.textColor = TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1;
    }
    
    if (self.areaListModel.list.count > 0) {
        TPAreaModel *tmpModel = self.areaListModel.list[row];
        cell.textLabel.text = tmpModel.name;
    }
    
    return cell;
}

//MARK: -- UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    TPAreaModel *tmpModel = self.areaListModel.list[row];
    
    self.areaID = tmpModel.areaID;
    
    self.myTableHeaderView.selectedAreaModel = tmpModel;
    
    if (_selectedAreaBlock) {
        _selectedAreaBlock(tmpModel);
    }
    
    if (row == self.areaListModel.list.count - 1) {
        [self close];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = self.myTableHeaderView.bounds.size.height;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

//MARK: -- 懒加载区域
//MARK: -- lazyload backView
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:MainScreenBounds];
        [_backView setBackgroundColor:[UIColor blackColor]];
        _backView.alpha = 0.5;
    }
    
    return _backView;
}

//MARK: -- lazyload addressTextView
- (TPAreaListTableHeaderView *)myTableHeaderView {
    if (!_myTableHeaderView) {
        _myTableHeaderView = [TPAreaListTableHeaderView instanceAreaListTableHeaderView];
    }
    
    return _myTableHeaderView;
}
//MARK: -- lazyload areaListModel
- (TPAreaListModel *)areaListModel {
    if (!_areaListModel) {
        _areaListModel = TPAreaListModel.new;
    }
    
    return _areaListModel;
}

//MARK: -- 请求网络
- (void)requestAreaListData {
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @strongify(self);
        [self getAreaListSuccess:^(id json) {
            @strongify(self);
            self.areaListModel = [TPAreaListModel modelWithDictionary:json];
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.myTableView reloadData];
            });
        } failure:^(NSString *error) {
        }];
    });
}
//获取区接口
- (void)getAreaListSuccess:(void(^)(id json))success
                   failure:(void (^)(NSString *error))failure {
    [[YHTTPService sharedInstance] requestAreaList:self.areaID success:^(YHTTPResponse *response) {
        if (response.code == YHTTPResponseCodeSuccess) {
            success(response.parsedResult);
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    } failure:^(NSString *msg) {
        failure(msg);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
