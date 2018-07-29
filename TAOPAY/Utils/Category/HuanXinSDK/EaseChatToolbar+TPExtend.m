//
//  EaseChatToolbar+TPExtend.m
//  TAOPAY
//
//  Created by admin on 2018/7/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "EaseChatToolbar+TPExtend.h"

@implementation EaseChatToolbar (TPExtend)

- (void)updateToolbarItemIndex:(NSInteger)index withNormalImage:(NSString *)normalImage withSelectedImage:(NSString *)selectedImage withIsLeft:(BOOL)isLeft {
    EaseChatToolbarItem *styleItem = isLeft?self.inputViewLeftItems[index]:self.inputViewRightItems[index];
    [styleItem.button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [styleItem.button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
}

- (void)removeToolbarItemIndex:(NSInteger)index withSide:(BOOL)isLeft {
    
    if (isLeft) {
        if (index > self.inputViewLeftItems.count - 1) {
            return;
        }
        
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        [tmpArr addObjectsFromArray:self.inputViewLeftItems];
        
        [tmpArr removeObjectAtIndex:index];
        self.inputViewLeftItems = tmpArr;
        
    } else {
        if (index > self.inputViewRightItems.count - 1) {
            return;
        }
        
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        [tmpArr addObjectsFromArray:self.inputViewRightItems];
        
        [tmpArr removeObjectAtIndex:index];
        self.inputViewRightItems = tmpArr;
    }
}

@end
