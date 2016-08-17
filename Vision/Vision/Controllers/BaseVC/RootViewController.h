//
//  RootViewController.h
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
//左按钮
@property (nonatomic,strong) UIButton * leftButton;
//标题
@property (nonatomic,strong) UILabel * titleLabel;
//右按钮
@property (nonatomic,strong) UIButton * rightButton;

//响应方法
-(void)addLeftTarget:(SEL)selector;
-(void)addRightTarget:(SEL)selector;
@end
