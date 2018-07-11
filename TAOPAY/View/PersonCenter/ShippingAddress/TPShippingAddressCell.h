//
//  TPShippingAddressCell.h
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YBaseTableViewCell.h"

@class TPAddressModel;

typedef void(^TPClickCellDeleteButtonsHandler)(TPAddressModel *addressModel);
typedef void(^TPClickCellEditButtonsHandler)(TPAddressModel *addressModel);
typedef void(^TPClickCellSetTopButtonsHandler)(TPAddressModel *addressModel);
typedef void(^TPClickCellSetDefaultButtonsHandler)(TPAddressModel *addressModel);

@interface TPShippingAddressCell : YBaseTableViewCell

@property (copy, nonatomic) TPAddressModel *addressModel;
@property (nonatomic, copy) TPClickCellDeleteButtonsHandler deleteBlock;
@property (nonatomic, copy) TPClickCellEditButtonsHandler editBlock;
@property (nonatomic, copy) TPClickCellSetTopButtonsHandler setTopBlock;
@property (nonatomic, copy) TPClickCellSetDefaultButtonsHandler setDefaultBlock;

@end
