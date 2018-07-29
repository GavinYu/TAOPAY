//
//  TPPersonalHomepageViewController.h
//  TAOPAY
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTableViewController.h"

typedef void(^TPSelectedFriendHandler)(NSString *username);

@interface TPPersonalHomepageViewController : TPTableViewController

@property (copy, nonatomic) TPSelectedFriendHandler selectedFriendBlock;

@end
