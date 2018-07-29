//
//  TPUserInfoListModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@class TPUserInfoModel;

@interface TPUserInfoListModel : YObject

//商品列表
@property (strong, nonatomic) NSArray <TPUserInfoModel *>*info;

@end
