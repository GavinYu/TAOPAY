//
//  TPBalanceDetailModel.h
//  TAOPAY
//
//  Created by admin on 2018/5/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@class TPBalanceDetailItemModel;

@interface TPBalanceDetailModel : YObject

@property (nonatomic, strong) NSArray <TPBalanceDetailItemModel *> *list;

@end
