//
//  TPShoppingCartCell.h
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YBaseTableViewCell.h"

@class TPShoppingCartCell;
@class TPCartGoodsViewModel;

typedef void(^TPShoppingCartCellSelectHandler)(TPShoppingCartCell *cell);
typedef void(^TPShoppingCartCellAddHandler)(TPShoppingCartCell *cell);
typedef void(^TPShoppingCartCellSubHandler)(TPShoppingCartCell *cell);
typedef void(^TPShoppingCartCellDeleteHandler)(TPShoppingCartCell *cell);
typedef void(^TPShoppingCartCellCounteHandler)(TPShoppingCartCell *cell);

@interface TPShoppingCartCell : YBaseTableViewCell

@property (copy, nonatomic) TPShoppingCartCellSelectHandler selectBlock;
@property (copy, nonatomic) TPShoppingCartCellAddHandler addBlock;
@property (copy, nonatomic) TPShoppingCartCellSubHandler subBlock;
@property (copy, nonatomic) TPShoppingCartCellDeleteHandler deleteBlock;
@property (copy, nonatomic) TPShoppingCartCellCounteHandler countBlock;

@property (nonatomic, readonly, strong) TPCartGoodsViewModel *viewModel;


@end
