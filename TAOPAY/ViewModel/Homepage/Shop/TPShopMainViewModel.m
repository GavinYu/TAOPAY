//
//  TPShopMainViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShopMainViewModel.h"

#import "YHTTPService.h"
#import "TPAppConfig.h"
#import "YLocationModel.h"
#import "TPShopHomepageModel.h"

@implementation TPShopMainViewModel

//MARK: --  获取商城首页信息
- (void)getShopMainSuccess:(void(^)(id json))success
                   failure:(void (^)(NSString *error))failure {
    NSString *tmpLat = [NSString stringWithFormat:@"%.8f", self.currentLocationModel.currentLocation.coordinate.latitude];
    NSString *tmpLon = [NSString stringWithFormat:@"%.8f", self.currentLocationModel.currentLocation.coordinate.longitude];
    
    @weakify(self);
    [[YHTTPService sharedInstance] requestShopMainWithLatitude:tmpLat longitude:tmpLon page:self.page success:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            TPShopHomepageModel *tmpModel = TPShopHomepageModel.new;
            tmpModel = [TPShopHomepageModel modelWithDictionary:response.parsedResult];
            self.shopHomepageModel = tmpModel;
            success(@YES);
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
            failure(response.message);
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

@end
