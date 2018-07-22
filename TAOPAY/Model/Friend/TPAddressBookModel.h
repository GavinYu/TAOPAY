//
//  TPAddressBookModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/21.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@interface TPAddressBookModel : YObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, strong) NSData *avatar;

@end
