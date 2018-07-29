//
//  TPPublishHeaderCollectionReusableView.h
//  TAOPAY
//
//  Created by admin on 2018/7/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPPublishHeaderCollectionReusableView;

typedef void(^TPClickCancelEventHandler)(UIButton *sender);
typedef void(^TPClickCommitEventHandler)(TPPublishHeaderCollectionReusableView *sender);

@interface TPPublishHeaderCollectionReusableView : UICollectionReusableView

@property (copy, nonatomic) TPClickCancelEventHandler cancelBlock;
@property (copy, nonatomic) TPClickCommitEventHandler commitBlock;

@property (readonly, copy, nonatomic) NSString *content;

+ (TPPublishHeaderCollectionReusableView *)instanceView;

@end
