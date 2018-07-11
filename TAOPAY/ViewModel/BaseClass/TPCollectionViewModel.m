//
//  TPCollectionViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPCollectionViewModel.h"

@implementation TPCollectionViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        _page = 1;
        _perPage = 20;
        _lastPage = 1;
    }
    return self;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark - sub class can ovrride it
/// 加载数据
- (void)loadData:(void(^)(id json))success
         failure:(void(^)(NSError *error))failure
    configFooter:(void(^)(BOOL isLastPage))configFooter {
    // 子类重载
}

- (id)fetchLocalData {
    return nil;
}

- (NSUInteger)offsetForPage:(NSUInteger)page {
    return (page - 1) * self.perPage;
}

@end
