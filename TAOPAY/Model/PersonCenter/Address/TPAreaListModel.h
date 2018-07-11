//
//  TPAreaListModel.h
//  TAOPAY
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@class TPAreaModel;

@interface TPAreaListModel : YObject

//地址列表
@property (strong, nonatomic) NSArray <TPAreaModel *>*list;

@end
