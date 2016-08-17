//
//  ReadViewController.m
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "ReadViewController.h"
#import "StoryViewController.h"
#import "NewsViewController.h"
@interface ReadViewController ()<UIScrollViewDelegate>{
    UIScrollView * _scrollView;
}
//title名称
@property (nonatomic,strong) NSArray * titleArray;
@end

@implementation ReadViewController
- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.barTintColor = RGB(220, 218, 206, 1);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航
    [self createNav];
    [self createScrollView];
}
#pragma mark - 创建ScrollView
- (void)createScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    //设置contectSize
    _scrollView.contentSize = CGSizeMake(2 * kWidth, 0);
    //实例化子控制器
    StoryViewController * storyVC = [[StoryViewController alloc]init];
    storyVC.view.backgroundColor = [UIColor redColor];
    
    NewsViewController  * newsVC = [[NewsViewController alloc]init];
    newsVC.view.backgroundColor = [UIColor cyanColor];
    
    NSArray * array = @[storyVC,newsVC];
    
    int i = 0;
    for (UIViewController * VC in array) {
        VC.view.frame = CGRectMake( i * kWidth, 0, kWidth, kHeight);
        [self addChildViewController:VC];
        [_scrollView addSubview:VC.view];
        i ++;
    }
}
#pragma mark - 设置导航
- (void)createNav{
    
    _titleArray = @[@"故事",@"创作"];
    self.titleLabel.text = _titleArray[0];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 反向关联
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x / kWidth;
    self.titleLabel.text = _titleArray[index];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
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
