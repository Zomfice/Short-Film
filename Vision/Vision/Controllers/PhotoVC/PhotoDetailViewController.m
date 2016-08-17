//
//  PhotoDetailViewController.m
//  Vision
//
//  Created by QianFeng on 16/6/16.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "PhotoModel.h"
@interface PhotoDetailViewController ()<UIScrollViewDelegate>{
    UIScrollView * _scrollView;
    UIPageControl * _pageControl;
    UIImageView * _imageView;
    BOOL _isPan;
}
@property (nonatomic,strong) NSMutableArray * imageList;
@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.navigationController.navigationBarHidden = NO;
    [self resetNav];
    [self getData];
    [self createUI];
    [self createPageControl];
}
#pragma mark - 滑动隐藏导航栏
- (void)hideBar{
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 设置导航
- (void)resetNav{
    //self.navigationController.navigationBar.barTintColor = RGB(20, 20, 20, 1);//不能改变barTintColor颜色，要不然就是等于重写了父类方法，跳转界面返回的时候NavigationBar的颜色会发生改变，会显示黑色，界面跳转返回的时候，目标视图的Bar的颜色会影响到跳转视图的Bar的颜色
    //左按钮
    [self.leftButton setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [self addLeftTarget:@selector(backButtonClick)];
}
- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 得到图片数据
- (void)getData{
    for (PhotoModel * model in self.detailArray) {
        [self.imageList addObject:model.image_url];
    }
}
#pragma mark 创建UI
- (void)createUI{
    self.view.backgroundColor =  [UIColor blackColor];
    //创建scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    
    
    //设置contentSize
    _scrollView.contentSize = CGSizeMake(_detailArray.count * _scrollView.frame.size.width, 0);
    //创建imageView
    for (int i = 0; i < self.detailArray.count; i++) {
        
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(i * kWidth, 0, kWidth, kHeight);
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:self.imageList[i]]];
        //添加手势触摸
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:tap];
        [_scrollView addSubview:_imageView];
    }
    _scrollView.scrollEnabled = YES;
    //设置分页
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.contentOffset = CGPointMake(self.imageIndex * kWidth, 0);
    [self.view addSubview:_scrollView];
}
//触摸手势响应
-  (void)tapGesture:(UITapGestureRecognizer *)tgr{
    
    [UIView animateWithDuration:1 animations:^{
        if (!_isPan) {
            //_imageView.center = self.view.center;
            self.navigationController.navigationBarHidden = YES;
            
        }else{
            self.navigationController.navigationBarHidden = NO;
            //_imageView.center = self.view.center;
        }
    }];

    _isPan = !_isPan;
}
#pragma mark - UISCrollVIewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.isDragging) {
        //self.navigationController.navigationBarHidden = YES;

        NSInteger page = scrollView.contentOffset.x / kWidth + 0.5;
        _pageControl.currentPage = page;
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSLog(@"%f",velocity.x);
    NSLog(@"--%f",velocity.y);
    if (velocity.x > 0) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
#pragma mark - 创建分页控制
- (void)createPageControl{
    _pageControl = [[UIPageControl  alloc]initWithFrame:CGRectMake(0, kHeight - 100, kWidth, 50)];
    //设置页数
    _pageControl.numberOfPages = _imageList.count;
    //设置当前页
    _pageControl.currentPage = self.imageIndex;
    
    //_pageControl.backgroundColor = [UIColor redColor];
    //设置未选中的点的颜色
    _pageControl.pageIndicatorTintColor = RGB(220, 218, 206, 1);
    //设置选中点的颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
}
- (void)pageChanged:(UIPageControl *)pageControl{
    CGPoint offset = _scrollView.contentOffset;
    offset.x = kWidth * pageControl.currentPage;
    [_scrollView setContentOffset:offset animated:YES];
}
#pragma mark - imageList懒加载
- (NSMutableArray *)imageList{
    if (_imageList == nil) {
        _imageList = [[NSMutableArray alloc]init];
    }
    return _imageList;
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
