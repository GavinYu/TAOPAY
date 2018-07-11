//
//  TPWalletModel.h
//  TAOPAY
//
//  Created by admin on 2018/4/19.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@interface TPWalletModel : YObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *type;

@end
