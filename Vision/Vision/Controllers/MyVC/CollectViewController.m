//
//  CollectViewController.m
//  Vision
//
//  Created by QianFeng on 16/6/27.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectCell.h"
#import "EveryDayModel.h"
#import "DBManager.h"
#import "KRVideoPlayerController.h"

@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
}

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) KRVideoPlayerController * videoController;
@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self resetNav];
    [self createUI];
    [self loadData];
}
#pragma mark - 获取数据 -
- (void)loadData{
    //获取单例对象
    DBManager * manager = [DBManager defaultManager];
    NSArray * array  = [manager getData];
    //数组的初始化
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [_tableView reloadData];
}
#pragma mark - 创建UI - 
- (void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView registerNib:[UINib nibWithNibName:@"CollectCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    _tableView.estimatedRowHeight = 200;
}
#pragma mark - tableView代理方法实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    EveryDayModel  *  model = self.dataArray[indexPath.row];
    
    if (self.dataArray.count > 0) {
        [cell.imageViewL sd_setImageWithURL:[NSURL URLWithString:model.coverForDetail]];
        cell.titleL.text = model.title;
        
        cell.CategoryL.text = [NSString stringWithFormat:@"#%@#",model.category];
        cell.descripL.text = model.descrip;
    }
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 100;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EveryDayModel * model = self.dataArray[indexPath.row];
    [self playVideoWithURL:[NSURL URLWithString:model.playUrl]];
}
#pragma mark - 视频播放 -
- (void)playVideoWithURL:(NSURL *)url
{
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController showInWindow];
    }
    self.videoController.contentURL = url;
    [_videoController playButtonClick];
    [_videoController fullScreenButtonClick];
}
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
    //分为三个步骤：1.删除数据库中的数据 2.删除当前控制器对应数据源中的数据 3.删除对应的cell
    DBManager * manager = [DBManager defaultManager];
    EveryDayModel * model = self.dataArray[indexPath.row];
    [manager deleteNameFromTable:model.ID];
    
    [self.dataArray removeObjectAtIndex:indexPath.row];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - 设置导航 -
- (void)resetNav{
    [self.leftButton setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [self addLeftTarget:@selector(backButtonClick)];
    self.titleLabel.text = @"我的收藏";
}
//返回事件
- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
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
