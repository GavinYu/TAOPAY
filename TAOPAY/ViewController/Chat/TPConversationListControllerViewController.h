//
//  TPConversationListControllerViewController.h
//  TAOPAY
//
//  Created by admin on 2018/7/28.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EaseConversationListViewController.h"

@interface TPConversationListControllerViewController :  EaseConversationListViewController

@property (strong, nonatomic) NSMutableArray *conversationsArray;

- (void)refresh;
- (void)refreshDataSource;

@end
