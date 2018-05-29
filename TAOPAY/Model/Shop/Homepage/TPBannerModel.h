//
//  TPBannerModel.h
//  TAOPAY
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@interface TPBannerModel : YObject

//banner图片
@property (copy, nonatomic) NSString *image;
//商家ID
@property (copy, nonatomic) NSString *link;

@end
