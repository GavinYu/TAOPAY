//
//  YNavigationBar.m
//  TAOPAY
//
//  Created by admin on 2018/4/15.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YNavigationBar.h"

#import "TPMacros.h"

@interface YNavigationBar ()
@property (nonatomic,strong)leftBtnBlock leftBlock;
@property (nonatomic,strong)rightBtnBlock rightBlock;
@end

@implementation YNavigationBar
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, APPWIDTH, NAVGATIONBARHEIGHT)];
        bgView.backgroundColor = TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1;
        
        [self addSubview:bgView];
        
        self.leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.frame=CGRectMake(0, 0, 50, 50);
        self.leftBtn.contentEdgeInsets=UIEdgeInsetsMake(10, 10, 10, 10);
        self.leftBtn.center=CGPointMake(28, NAVGATIONBARHEIGHT-22);
        [self.leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:self.leftBtn];
        self.leftBtn.accessibilityIdentifier=@"navLeftButton";
        
        self.rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.bounds=CGRectMake(0, 0, 80, 40);
        self.rightBtn.center=CGPointMake(APPWIDTH-35, NAVGATIONBARHEIGHT-22);
        [self.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:self.rightBtn];
        self.rightBtn.accessibilityIdentifier=@"navRightButton";
        
        self.titleLable=[[UILabel alloc]init];
        self.titleLable.backgroundColor=[UIColor clearColor];
        self.titleLable.bounds=CGRectMake(0, 0, 200, 40);
        self.titleLable.center=CGPointMake(APPWIDTH/2, NAVGATIONBARHEIGHT-22);
        self.titleLable.textAlignment=NSTextAlignmentCenter;
        // self.titleLable.backgroundColor = [UIColor redColor];
        self.titleLable.textColor = [UIColor clearColor];
        self.titleLable.textColor = [UIColor whiteColor];
        self.titleLable.font = [UIFont systemFontOfSize:18];
        [self addSubview:self.titleLable];
    }
    return self;
}

#pragma mark- leftBtn
-(void)leftBtnClick:(id)sender
{
    if(self.leftBlock!=nil){
        self.leftBlock(nil);
    }
}

-(void)leftBtnBlock:(leftBtnBlock)newblock
{
    self.leftBlock=newblock;
}

#pragma mark- rightBtn
-(void)rightBtnClick:(id)sender
{
    if(self.rightBlock!=nil){
        self.rightBlock(nil);
    }
}

-(void)rightBtnBlock:(rightBtnBlock)newblock
{
    self.rightBlock=newblock;
}

#pragma mark- view

-(void)setTitleName:(NSString *)titleName leftBtnName:(NSString *)leftBtnName rightBtnName:(NSString *)rightBtnName
{
    if (titleName != nil) {
        
        self.titleLable.hidden=NO;
        self.titleLable.text=titleName;
        
    }else{
        self.titleLable.hidden=YES;
    }
    if (leftBtnName !=nil) {
        if ([leftBtnName hasSuffix:@"png"]) {
            UIImage* limage=[UIImage imageNamed:leftBtnName];
            [self.leftBtn setImage:limage forState:UIControlStateNormal];
            self.leftBtn.center=CGPointMake(limage.size.width/2+15, NAVGATIONBARHEIGHT-22);
        }else{
            self.leftBtn.center=CGPointMake(28, NAVGATIONBARHEIGHT-22);
            
            [self.leftBtn setTitle:leftBtnName forState:UIControlStateNormal];
        }
    }else{
        self.leftBtn.hidden=YES;
    }
    
    
    if (rightBtnName !=nil) {
        if ([rightBtnName hasSuffix:@"png"]) {
            UIImage* rimage=[UIImage imageNamed:rightBtnName];
            [self.rightBtn setImage:rimage forState:UIControlStateNormal];
            self.rightBtn.center=CGPointMake(APPWIDTH-rimage.size.width/2-15, NAVGATIONBARHEIGHT-22);
            
        }else{
            self.rightBtn.center=CGPointMake(APPWIDTH-35, NAVGATIONBARHEIGHT-22);
            [self.rightBtn setTitle:rightBtnName forState:UIControlStateNormal];
        }
    }else{
        self.rightBtn.hidden=YES;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
