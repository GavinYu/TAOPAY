//
//  FBKVOController+YExtension.m
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "FBKVOController+YExtension.h"

@implementation FBKVOController (YExtension)
- (void)y_observe:(id)object keyPath:(NSString *)keyPath block:(FBKVONotificationBlock)block
{
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:block];
}

- (void)y_observe:(id)object keyPath:(NSString *)keyPath action:(SEL)action
{
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew action:action];
}
@end
