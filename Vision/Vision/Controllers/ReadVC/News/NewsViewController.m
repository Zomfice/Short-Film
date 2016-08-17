//
//  NewsViewController.m
//  Vision
//
//  Created by QianFeng on 16/6/13.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "NewsViewController.h"
#import "StoryCell.h"
#import "ArticalModel.h"
#import "StoryDetailViewController.h"
@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView * _tableView;
}
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createRefresh];
}
#pragma mark - 请求数据
- (void)createRefresh{
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [_tableView.header beginRefreshing];
}
- (void)loadNewData{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self getData];
}
- (void)getData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    [manager POST:MoreStoryURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * array = responseObject[@"data"];
        for (NSDictionary *dic in array) {
            ArticalModel * model = [[ArticalModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [_tableView.header endRefreshing];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
#pragma mark - 创建UI
- (void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor  = RGB(220, 218, 206, 1);
    [self.view addSubview:_tableView];
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"StoryCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _tableView.estimatedRowHeight = 300;
}
#pragma mark - 实现代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StoryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //赋值
    if (self.dataArray.count > 0) {
        ArticalModel * model = self.dataArray[indexPath.row];
        [cell refreshUI:model];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //实例化
    StoryDetailViewController * detailVC = [[StoryDetailViewController alloc]init];
    //传值
    ArticalModel * model = self.dataArray[indexPath.row];
    detailVC.model = model;
    detailVC.titleString = @"创作详情";
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController  pushViewController:detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
