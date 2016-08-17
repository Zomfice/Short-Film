//
//  StoryDetailViewController.m
//  Vision
//
//  Created by QianFeng on 16/6/14.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "StoryDetailViewController.h"
#import "UMSocial.h"
#import "DBManager.h"
@interface StoryDetailViewController (){
    UIWebView * _webView;
}

@end

@implementation StoryDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.barTintColor = RGB(220, 218, 206, 1);
    DBManager * manager = [DBManager defaultManager];
    if ([manager isHasDataIDFromTable:self.model.storyid]) {
        //收藏按钮保持选中状态
        UIButton  * collection = [self.view viewWithTag:10];
        collection.selected = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetNav];
    [self createUI];
}
#pragma mark - 创建UI
- (void)createUI{
    //创建webView
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    //设置网页自适配
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_model.shareurl]]];
    [self.view addSubview:_webView];
    
    //收藏按钮
    UIButton * collectionButton = [FactoryUI createButtonWithFrame:CGRectMake(kWidth - 70, 40, 50, 50) title:nil titleColor:nil backgroundColor:nil type:UIButtonTypeCustom target:self selector:@selector(collectButtonClick:)];
    //未收藏前
    [collectionButton setImage:[UIImage imageNamed:@"iconfont-iconfontshoucang"] forState:UIControlStateNormal];
    //收藏之后
    [collectionButton setImage:[UIImage imageNamed:@"iconfont-iconfontshoucang-2"] forState:UIControlStateSelected];
    collectionButton.tag = 10;
    [self.view addSubview:collectionButton];
}
#pragma mark - 设置导航
- (void)resetNav{
    //左按钮
    [self.leftButton setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [self addLeftTarget:@selector(backButtonClick)];
    //标题
    self.titleLabel.text = _titleString;
    
    [self.rightButton setImage:[UIImage imageNamed:@"iconfont-fenxiang"] forState:UIControlStateNormal];
    [self addRightTarget:@selector(shareButtonClick)];
    
}
- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)shareButtonClick{
    //UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@""]]];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"507fcab25270157b37000010" shareText:_model.shareurl shareImage:nil shareToSnsNames:@[UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline] delegate:nil];
}
#pragma mark - 收藏
- (void)collectButtonClick:(UIButton *)button{
    button.selected = YES;
    
    
    
    NSLog(@"-----%@",self.model.storyid);
    
    //获取单例对象
    DBManager * mananger = [DBManager defaultManager];
    //查询
    if ([mananger isHasDataIDFromTable:self.model.storyid]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经收藏过了" preferredStyle:UIAlertControllerStyleAlert];
        //确定按钮
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        //进行收藏
        [mananger insertDataModel:self.model];
    }
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
