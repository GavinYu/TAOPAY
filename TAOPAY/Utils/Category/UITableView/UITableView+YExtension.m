//
//  UITableView+YExtension.m
//  TAOPAY
//
//  Created by admin on 2018/4/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "UITableView+YExtension.h"

@implementation UITableView (YExtension)

- (void)y_registerCell:(Class)cls {
    
    [self y_registerCell:cls forCellReuseIdentifier:NSStringFromClass(cls)];
}
- (void)y_registerCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerClass:cls forCellReuseIdentifier:reuseIdentifier];
}

- (void)y_registerNibCell:(Class)cls {
    [self y_registerNibCell:cls forCellReuseIdentifier:NSStringFromClass(cls)];
}
- (void)y_registerNibCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(cls) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}

@end
