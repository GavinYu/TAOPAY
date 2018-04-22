//
//  YNavigationBar.h
//  TAOPAY
//
//  Created by admin on 2018/4/15.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^leftBtnBlock)(id);
typedef void(^rightBtnBlock)(id);

@interface YNavigationBar : UIView

@property (nonatomic,strong)UIButton * leftBtn;
@property (nonatomic,strong)UIButton * rightBtn;
@property (nonatomic,strong)UILabel  *titleLable;

-(void)leftBtnBlock:(leftBtnBlock)newblock;

-(void)rightBtnBlock:(rightBtnBlock)newblock;

/**
 *设置导航
 *
 *  @param titleName
 *  @param leftBtnName
 *  @param rightBtnName
 */
-(void)setTitleName:(NSString *)titleName leftBtnName:(NSString *)leftBtnName rightBtnName:(NSString *)rightBtnName;

@end
