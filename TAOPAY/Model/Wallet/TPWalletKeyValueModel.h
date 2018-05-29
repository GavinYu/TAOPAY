//
//  TPWalletKeyValueModel.h
//  TAOPAY
//
//  Created by admin on 2018/4/19.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@interface TPWalletKeyValueModel : YObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) BOOL isHaveImage;
@property (nonatomic, copy) NSString *textFieldPlaceholder;

@end
