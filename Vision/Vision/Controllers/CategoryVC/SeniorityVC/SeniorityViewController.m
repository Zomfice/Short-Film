//
//  SeniorityViewController.m
//  Vision
//
//  Created by QianFeng on 16/6/30.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "SeniorityViewController.h"
#import "CommonTViewController.h"

@interface SeniorityViewController ()<UIScrollViewDelegate>{
    //上滑条
    UIView * _lineTopView;
    //下滑条
    UIView * _lineBottomView;
    //标题
    NSString * _titleString;
    //分类ID
    NSString * _strategyID;
    UIScrollView * _scrollView;
    UIButton * _button;
}
//数据
@property (nonatomic,strong)  NSMutableArray * dataArray;
//按钮数组
@property (nonatomic,strong) NSMutableArray * buttonArray;
@end

@implementation SeniorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //初始化数据
    [self initSomeData];
    //设置导航
    [self resetNav];
    //创建头部视图
    [self createHeaderView];
    [self createScrollView];
}
-(void)viewWillAppear:(BOOL)animated
{
    for (UIButton * btn in self.buttonArray) {
        if (btn == [self.buttonArray firstObject]) {
            btn.selected = YES;
        }
    }
}

#pragma mark - 创建ScrollView
- (void)createScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, kWidth, kHeight)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    //设置contentSize
    _scrollView.contentSize =  CGSizeMake(3 * kWidth, 0);
    CommonTViewController *View1 = [[CommonTViewController alloc]init];
    View1.SenegalURL = _strategyID;
    View1.SenegalNum = 10;
    View1.view.backgroundColor = [UIColor whiteColor];
    CommonTViewController * View2 = [[CommonTViewController alloc]init];
    View2.SenegalURL = @"monthly";
    View2.SenegalNum = 11;
    View2.view.backgroundColor = [UIColor whiteColor];
    CommonTViewController * View3 = [[CommonTViewController alloc]init];
    View3.view.backgroundColor = [UIColor whiteColor];
    View3.SenegalURL = @"historical";
    View3.SenegalNum = 12;
    NSArray * arr = @[View1,View2,View3];
    int i = 0;
    for (UIViewController * VC in arr) {
        VC.view.frame = CGRectMake(i * kWidth, 0, kWidth, kHeight -  104);
    
        [self addChildViewController:VC];
        [_scrollView addSubview:VC.view];
        i++;
    }
    [self.view addSubview:_scrollView];
}
#pragma mark - scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    for (UIButton * btn  in self.buttonArray) {
        if (btn.selected == YES) {
            btn.selected = NO;
        }
    }
    int index= scrollView.contentOffset.x / kWidth;
    UIButton * btn = self.buttonArray[index];
    //改变滑条的位置
    [UIView animateWithDuration:0.3 animations:^{
        btn.selected = YES;
        _lineTopView.frame = CGRectMake(index  * kWidth / 3 + 40, 0, kWidth / 3 - 80, 1);
        _lineBottomView.frame = CGRectMake(index * kWidth / 3 + 40, 39, kWidth / 3 -  80, 1);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
}
#pragma mark - 初始化数据 -
- (void)initSomeData{
    _buttonArray = [NSMutableArray arrayWithCapacity:0];
    _titleString = @"周排行";
    _strategyID = @"weekly";
}
#pragma mark - 设置导航 -
-  (void)resetNav{
    self.titleLabel.text = @"排行";
    self.navigationController.navigationBar.barTintColor = RGB(255, 255, 255, 1);
}
#pragma mark - 创建头部按钮
- (void)createHeaderView{
    NSArray * titleArray = @[@"周排行",@"月排行",@"总排行"];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton * headerButton = [FactoryUI    createButtonWithFrame:CGRectMake(i * kWidth / 3, 0, kWidth / 3, 40) title:titleArray[i] titleColor:[UIColor blackColor] backgroundColor:RGB(242, 242, 242, 1) type:UIButtonTypeCustom target:self selector:@selector(headrButtonClick:)];
        headerButton.titleLabel.font = [UIFont systemFontOfSize:13];
        //设置选中文字的颜色
        [headerButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        headerButton.tag = 100 + i;
        [self.view addSubview:headerButton];
        [self.buttonArray addObject:headerButton];
    }
    _lineTopView = [FactoryUI createViewWithFrame:CGRectMake(40, 0, kWidth / 3 - 80, 1)];
    _lineTopView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_lineTopView];
    _lineBottomView = [FactoryUI createViewWithFrame:CGRectMake(40, 39, kWidth / 3 - 80, 1)];
    _lineBottomView.backgroundColor = [UIColor blackColor];
    [self.view  addSubview:_lineBottomView];
}
#pragma mark - 按钮响应方法 -
-(void)headrButtonClick:(UIButton *)button{
   
    //改变滑条的位置
    [UIView animateWithDuration:0.4 animations:^{
        _lineTopView.frame = CGRectMake((button.tag - 100) * kWidth / 3 + 40, 0, kWidth / 3 - 80, 1);
        _lineBottomView.frame = CGRectMake((button.tag - 100) * kWidth / 3 + 40, 38, kWidth / 3 - 80, 1);
    }];
    for (UIButton * btn  in self.buttonArray) {
        if (btn.selected == YES) {
            btn.selected = NO;
        }
    }
    button.selected = YES;
    _titleString = button.titleLabel.text;
    
    switch (button.tag - 100) {
        case 0:
            _strategyID = @"weekly";
            break;
        case 1:
            _strategyID = @"monthly";
            break;
        case 2:
            _strategyID = @"historical";
            break;
        default:
            break;
    }
    
    _scrollView.contentOffset = CGPointMake((button.tag - 100) * kWidth, 0);
    CommonTViewController *  comVC = [[CommonTViewController  alloc]init];
    comVC.SenegalURL = _strategyID;


    //仅仅请求一下数据没有用，需要用到MJ刷新
    [comVC.tableView.header beginRefreshing];
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
