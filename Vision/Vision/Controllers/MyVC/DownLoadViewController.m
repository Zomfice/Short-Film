//
//  DownLoadViewController.m
//  Vision
//
//  Created by QianFeng on 16/7/3.
//  Copyright © 2016年 Zomfice. All rights reserved.
//
#import "DownLoadViewController.h"
#import "DownLoadCell.h"
#import "TYDownLoadDataManager.h"
#import "DBManager.h"
#import "EveryDayModel.h"
@interface DownLoadViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
}
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation DownLoadViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self resetNav];
    [self createUI];
    [self loadData];
}
- (void)loadData{
    //获取单例对象
    DBManager * manager2 = [DBManager defaultManager2];
    NSArray * array  = [manager2 getData];
    //数组的初始化
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [_tableView reloadData];
}

#pragma markd - 创建UI
- (void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"DownLoadCell" bundle:nil] forCellReuseIdentifier:@"loadCell"];
    _tableView.estimatedRowHeight = 200;
     _tableView.tableFooterView = [[UIView alloc]init];
}
#pragma mark - 实现代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownLoadCell * cell = [tableView  dequeueReusableCellWithIdentifier:@"loadCell" forIndexPath:indexPath];
    EveryDayModel * model = self.dataArray[indexPath.row];

    cell.downloadUrl = model.playUrl;
    //NSLog(@"------%@",self.dataArray[indexPath.row]);
    [cell delet];
    [cell refreshDowloadInfo];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.coverForDetail]];
    cell.titleL.text = model.title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了cell");
//    NSIndexPath * indexPatht = [tableView indexPathForSelectedRow];
    DownLoadCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell play];
//    [cell deleteFileWithDownloadModel];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138;
}

#pragma mark - 实现下载的删除操作
//实现cell中数据的删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//设置cell的样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//实现删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //分为三个步骤：1.1实现先删除下载的数据 1.删除数据库中的数据 2.删除当前控制器对应数据源中的数据 3.删除对应的cell


    
    DownLoadCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell deleteFileWithDownloadModel];
    
    DBManager * manager2 = [DBManager defaultManager2];
    EveryDayModel * model = self.dataArray[indexPath.row];
    
    [manager2 deleteNameFromTable:model.ID];
    
    [self.dataArray removeObjectAtIndex:indexPath.row];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView reloadData];
}


#pragma mark - 设置导航返回
- (void)resetNav{
    self.navigationController.navigationBar.translucent = YES;
    [self.leftButton setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [self addLeftTarget:@selector(backButtonClick)];
    self.titleLabel.text = @"我的下载";
}
- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
