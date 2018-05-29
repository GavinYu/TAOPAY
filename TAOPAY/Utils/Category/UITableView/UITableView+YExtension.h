//
//  UITableView+YExtension.h
//  TAOPAY
//
//  Created by admin on 2018/4/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (YExtension)

/**
 * 使用以下两个方法注册的cell，identifier和类名保持一致
 * 推荐使用类名做cell的标识符
 * 使用该方法获取identifier字符串：
 * NSString *identifier = NSStringFromClass([UITableViewCell class])
 */
- (void)y_registerCell:(Class)cls;
- (void)y_registerNibCell:(Class)cls;

- (void)y_registerCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier;
- (void)y_registerNibCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier;

@end
