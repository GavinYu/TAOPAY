//
//  TPFriendViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/5/6.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPFriendViewModel.h"

#import "TPFriendModel.h"

@implementation TPFriendViewModel

//MARK: -- lazyload walletCommonModel
- (TPFriendModel *)friendModel {
    if (!_friendModel) {
        _friendModel = TPFriendModel.new;
    }
    
    return _friendModel;
}

@end
