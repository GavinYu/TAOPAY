//
//  YReactiveView.h
//  TAOPAY
//
//  Created by admin on 2018/4/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#ifndef YReactiveView_h
#define YReactiveView_h

#import <Foundation/Foundation.h>
/// A protocol which is adopted by views which are backed by view models.
@protocol YReactiveView <NSObject>

/// Binds the given view model to the view.
///
/// viewModel - The view model
- (void)bindViewModel:(id)viewModel;

@end

#endif /* YReactiveView_h */
