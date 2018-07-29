//
//  EaseChatToolbar+TPExtend.h
//  TAOPAY
//
//  Created by admin on 2018/7/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "EaseChatToolbar.h"

@interface EaseChatToolbar (TPExtend)

- (void)updateToolbarItemIndex:(NSInteger)index withNormalImage:(NSString *)normalImage withSelectedImage:(NSString *)selectedImage withIsLeft:(BOOL)isLeft;

- (void)removeToolbarItemIndex:(NSInteger)index withSide:(BOOL)isLeft;

@end
