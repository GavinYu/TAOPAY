//
//  TPAreaModel.h
//  TAOPAY
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@interface TPAreaModel : YObject
//地区ID
@property (copy, nonatomic) NSString *areaID;
//名称
@property (copy, nonatomic) NSString *name;
@end
