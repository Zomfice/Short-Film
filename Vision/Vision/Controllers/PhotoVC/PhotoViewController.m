//
//  PhotoViewController.m
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//
#import "AppDelegate.h"

#import "PhotoViewController.h"
#import "HeaderView.h"
#import "NBWaterFlowLayout.h"

#import "PhotoCell.h"
//#import "PhotoTitleCell.h"
#import "PhotoModel.h"

#import "PhotoDetailViewController.h"
@interface PhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateWaterFlowLayout>{
    //头视图
    HeaderView * _headView;
    //BOOL _isSelect;
    
    //collectionView
    UICollectionView * _collectionView;
    //分页
    int _page;
}
@property (nonatomic,strong) HeaderView * headView;
//中间按钮
@property (nonatomic,strong) UIButton * titleButton;
//头部分类
@property (nonatomic,copy) NSString * headerPage;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation PhotoViewController

//- (void)viewWillAppear:(BOOL)animated{
//     self.navigationController.navigationBar.barTintColor = RGB(220, 218, 206, 1);
//
//    //[_collectionView.header beginRefreshing];
//    //[_collectionView reloadData];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
    [self initSomeData];
    //设置导航
    [self createNav];
    //创建UI
    [self createUI];
    //创建刷新
    [self createRefresh];
}
- (void)initSomeData{
    _headerPage = @"All";
}
#pragma mark - 创建UI
- (void)createUI{
    //创建网格布局对象
    NBWaterFlowLayout * flowlayout = [[NBWaterFlowLayout alloc]init];
    //设置网格的大小
    flowlayout.itemSize  = CGSizeMake((kWidth - 40) / 3, 180);
    flowlayout.numberOfColumns = 3;
    flowlayout.delegate = self;
    //设置边界距离
    flowlayout.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    //创建网格对象
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) collectionViewLayout:flowlayout];
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //设置背景颜色
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    //注册cell
    //[_collectionView registerClass:[PhotoTitleCell class] forCellWithReuseIdentifier:@"titleCell"];
    [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photoCell"];
}
#pragma mark - 实现代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //return self.dataArray ? self.dataArray.count + 1 : 0;
    return self.dataArray.count;
}
//创建cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    //赋值
    if (self.dataArray.count > 0) {
        PhotoModel * model = self.dataArray[indexPath.row];
        [cell refreshUI:model];
    }
    return cell;
}
//确定item的高度
- (CGFloat)collectionView:(UICollectionView *)collectionView waterFlowLayout:(NBWaterFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoDetailViewController * detailVC = [[PhotoDetailViewController alloc]init];
    detailVC.detailArray = self.dataArray;
    detailVC.imageIndex = indexPath.row;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - 设置导航
- (void)createNav{
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleButton.frame = CGRectMake(0, 0, 100, 40);
    [_titleButton setTitle:@"美图" forState:UIControlStateNormal];
    [_titleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleButton;
    //创建NavigationBar头视图
    _headView = [[HeaderView alloc]initWithFrame:CGRectMake(0,- 200, kWidth, 200) Width:kWidth Color:[UIColor whiteColor]];
    _headView.backgroundColor = [UIColor whiteColor];
    
    //Block传递值回调
    self.headView.headPage = ^(NSString * headCategory){
        _headerPage = headCategory;
        //NSLog(@"%@",headCategory);
    };
   /*
    头视图添加，是添加到self.view上还是添加到APP的根视图上，添加到根视图上，点击按钮，可以从顶部弹出，但是要想从navigationBar底部弹出，就会覆盖的navigationBar的视图内容.添加到_collectionView上点击button 没有反应，因为弹出的View的self.View的底部，覆盖,添加到NavigationController的最前面也是无法显示，添加到NavigationBar上的前视图上可以。
    */
    /*
     [self.view addSubview:_headView];
     UIApplication  * app = [UIApplication sharedApplication];
     AppDelegate * delegate = app.delegate;
     [delegate.window addSubview:_headView];
     //关闭用户交互
     
     */
    UIApplication  * app = [UIApplication sharedApplication];
    AppDelegate * delegate = app.delegate;
    [delegate.window addSubview:_headView];
    self.headView.userInteractionEnabled = YES;
//    [self.navigationController.navigationBar insertSubview:_headView atIndex:0];
}
#pragma mark - 创建刷新
- (void)createRefresh{
    //下拉刷新
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //[self loadNewData];
    //上拉加载更多
    _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_collectionView.header beginRefreshing];
}
- (void)loadNewData{
    //_headerPage = @"All";
    _page = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self getData];
}
- (void)loadMoreData{
    _page ++;
    [self getData];
}
- (void)getData{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSString *URL = [NSString stringWithFormat:MEIZI,_headerPage,_page];
    //NSLog(@"%@",URL);
    [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray * array = responseObject[@"results"];
        
        for (NSDictionary *dic in array) {
            PhotoModel * model = [[PhotoModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        
        if (_page == 1) {
            [_collectionView.header endRefreshing];
        }else{
            [_collectionView.footer endRefreshing];
        }
        [_collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - 按钮点击事件
- (void)titleButtonClick:(UIButton *)button{
    

    [UIView animateWithDuration:0.3 animations:^{
        if (!_isSelect) {
            
            _headView.frame = CGRectMake(0, 64, kWidth, 200);
            
        }else{
            _headView.frame = CGRectMake(0, - 200, kWidth, 200);
            
            //[_collectionView.header endRefreshing];
            //[_collectionView reloadData];
            [self createRefresh];
        }
    }];
    _isSelect = !_isSelect;
    NSLog(@"%@",_headerPage);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
