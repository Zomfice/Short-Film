//
//  FilmViewController.m
//  Vision
//
//  Created by QianFeng on 16/7/4.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "FilmViewController.h"
#import "FilmModel.h"
#import "FilmCell.h"
#import "FilmDetailViewController.h"
#define URL @"http://www.pgc.tv/v1/getdailyList?"
#define MOREURL @"http://www.pgc.tv/index.php?app=mobileapp&mod=Index&act=GetdailyList_v1&date=%@&num=10"
@interface FilmViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,copy) NSString *nextPageUrl;
@end

@implementation FilmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    
    [self getData:URL];
    [self createUI];
    [self createRefresh];
}
#pragma mark - 请求数据
-(void)createRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.header beginRefreshing];
}

-(void)loadNewData
{
    NSString * sting = URL;
    [self getData:sting];
}

-(void)loadMoreData
{
    NSArray * arr = [_nextPageUrl componentsSeparatedByString:@"date="];
    //NSLog(@"%@",arr);
    NSArray * arr1 = [arr[1] componentsSeparatedByString:@"&num"];
    //NSLog(@"%@",arr1[0]);
    NSString * string = arr1[0];
    NSString *url = [NSString stringWithFormat:MOREURL,string];
    //NSLog(@"%@",url);
    [self getData:url];
}
//数据加载
- (void)getData:(NSString *)filmURL{
    //NSLog(@"-------%@",filmURL);
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager GET:filmURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([filmURL isEqualToString:URL]) {
            [self.dataArray removeAllObjects];
        }
        
      //  NSLog(@"%@",responseObject);
        NSDictionary * dic = responseObject[@"data"];
        //下一个界面的url
        _nextPageUrl = dic[@"nextPageUrl"];
        
        NSArray * dailyList = dic[@"dailyList"];
        for (NSDictionary * videoDic in dailyList) {
            NSArray * videolist = videoDic[@"videolist"];
            for (NSDictionary * filmDic in videolist) {
                FilmModel * model = [[FilmModel alloc]init];
                [model setValuesForKeysWithDictionary:filmDic];
                //NSLog(@"%@",model.video_cate);
                [self.dataArray addObject:model];
            }
        }
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
       // NSLog(@"%@",self.dataArray);
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark -  创建UI -
- (void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"FilmCell" bundle:nil] forCellReuseIdentifier:@"filmCell"];
    _tableView.estimatedRowHeight = 200;
}
#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FilmCell * cell = [tableView dequeueReusableCellWithIdentifier:@"filmCell" forIndexPath:indexPath];
    FilmModel * filmModel =  self.dataArray[indexPath.row];
    [cell.imageViewL sd_setImageWithURL:[NSURL URLWithString:filmModel.adTrack]];
    cell.titleL.text = filmModel.title;
    cell.categoryL.text = filmModel.video_cate;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FilmDetailViewController * filmVC = [[FilmDetailViewController alloc]init];
    filmVC.modelF = self.dataArray[indexPath.row];
   filmVC.modalTransitionStyle =  UIModalTransitionStyleCrossDissolve;
    [self presentViewController:filmVC animated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
