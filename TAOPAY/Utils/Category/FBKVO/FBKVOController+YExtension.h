//
//  FBKVOController+YExtension.h
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "FBKVOController.h"

@interface FBKVOController (YExtension)
- (void)y_observe:(nullable id)object keyPath:(NSString *_Nullable)keyPath block:(FBKVONotificationBlock _Nullable )block;

- (void)y_observe:(nullable id)object keyPath:(NSString *_Nullable)keyPath action:(SEL _Nullable )action;
@end
