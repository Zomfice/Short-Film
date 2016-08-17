//
//  RootViewController.m
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRootNav];
}
- (void)createRootNav{
    //设置导航不透明
    self.navigationController.navigationBar.translucent = NO;
    //设置导航条的颜色
//    self.navigationController.navigationBar.barTintColor = RGB(220, 218, 206, 1);
    self.navigationController.navigationBar.barTintColor = RGB(242, 242, 242, 1);
    //左按钮
    self.leftButton = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 44, 44) title:nil titleColor:nil backgroundColor:nil type:UIButtonTypeCustom target:nil selector:nil];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    
    //标题
    self.titleLabel = [FactoryUI createLabelWithFrame:CGRectMake(0, 0, 100, 30) text:nil textColor:RGB(129, 129, 129, 1) backgroundColor:nil font:[UIFont boldSystemFontOfSize:18] textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView =  self.titleLabel;
    
    //右按钮
    self.rightButton = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 44, 44) title:nil titleColor:nil backgroundColor:nil type:UIButtonTypeCustom target:nil selector:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    
}

-(void)addLeftTarget:(SEL)selector
{
    [self.leftButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}

-(void)addRightTarget:(SEL)selector
{
    [self.rightButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
