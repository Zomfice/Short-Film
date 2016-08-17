//
//  MyViewController.m
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "MyViewController.h"
#import "AppDelegate.h"
#import "AboutViewController.h"
#import "CollectViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "DownLoadViewController.h"

@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>{
    //头部视图
    UIImageView * _headerImageView;
    UITableView * _tableView;
    //半透明View
    UIView * _darkView;
    
}
//logo
@property (nonatomic,strong) NSArray * logoArray;
//标题
@property (nonatomic,strong) NSArray * titleArray;

@property (nonatomic,strong) UILabel * labelHuanChun;

@end

@implementation MyViewController

static float originalImageHeight = 200;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetNav];
    [self createUI];
    [self initData];

}
//导航条颜色
- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.barTintColor = RGB(242, 242, 242, 1);
}
#pragma mark - 创建UI -
- (void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth-100, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //去掉多余的线条
    _tableView.tableFooterView = [[UIView alloc]init];
    
    _headerImageView = [FactoryUI createImageViewWithFrame:CGRectMake(0, -originalImageHeight, kWidth - 100, originalImageHeight) imageName:@"welcome1"];
    [_tableView addSubview:_headerImageView];
    
    _tableView.contentInset = UIEdgeInsetsMake(originalImageHeight, 0, 0, 0);
    
    //夜间模式
    _darkView = [FactoryUI createViewWithFrame:[UIScreen mainScreen].bounds];
}
#pragma mark - 实现代理方法 -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.logoArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        if (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 3) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row ==  2) {
            UISwitch * swi = [[UISwitch alloc]initWithFrame:CGRectMake(kWidth - 70-100, 5, 40, 34)];
            swi.tag = indexPath.row;
            [swi addTarget:self action:@selector(swiChangeValue:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:swi];
        }
        if (indexPath.row == 1) {
            _labelHuanChun = [FactoryUI createLabelWithFrame:CGRectMake(kWidth - 200, 5, 90, 34) text:nil textColor:nil backgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentRight];
            _labelHuanChun.adjustsFontSizeToFitWidth = YES;
            CGFloat mm = [self folerSizeWithPaht:[self getPath]];
            NSString * string= [NSString stringWithFormat:@"%.2f M",mm];
            _labelHuanChun.text = string;
            [cell.contentView addSubview:_labelHuanChun];
            //NSLog(@"%@",string);
        }
        
    }
    cell.imageView.image = [UIImage imageNamed:self.logoArray[indexPath.row]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}
#pragma mark - cell界面跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
        UINavigationController *vc =   nav.viewControllers[0];
        //我的收藏
        CollectViewController * collectVC = [[CollectViewController alloc]init];

        [vc  pushViewController:collectVC animated:YES];
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];

    }else if (indexPath.row == 4){
        
   UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
        UINavigationController *vc =   nav.viewControllers[0];
        AboutViewController *about  = [[AboutViewController alloc]init];
        
        //隐藏tabar
//        self.tabBarController.tabBar.hidden = YES;
        [vc pushViewController:about animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }else if (indexPath.row == 1){
        //清除缓存
        [self folerSizeWIthPath:[self getPath]];
    }else if (indexPath.row == 3){
        UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
        UINavigationController *vc =   nav.viewControllers[0];
        DownLoadViewController *about  = [[DownLoadViewController alloc]init];
        [vc pushViewController:about animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];

    }
}
#pragma mark - 清理缓存 -

#pragma mark - 计算缓存文件大小
- (NSString *)getPath{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    return path;
}

- (CGFloat)folerSizeWithPaht:(NSString *)path{
    //初始化文件管理类
    NSFileManager  * fileManager = [NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray * fileArray = [fileManager subpathsAtPath:path];
        for (NSString * fileName in fileArray) {
            NSString  * filePath =  [path stringByAppendingPathComponent:fileName];
            long fileSize = [fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
            folderSize = folderSize + fileSize / 1024.0/1024.0;
        }
        return folderSize;
    }
    return 0;
}
- (CGFloat)folerSizeWIthPath:(NSString *)path{
    //初始化文件管理类
    NSFileManager  * fileManager = [NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray * fileArray = [fileManager subpathsAtPath:path];
        for (NSString * fileName in fileArray) {
            NSString  * filePath =  [path stringByAppendingPathComponent:fileName];
            long fileSize = [fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
            folderSize = folderSize + fileSize / 1024.0/1024.0;
        }
        [self deleteFileSize:folderSize];
        return folderSize;
    }
    return 0;
}
#pragma mark - 弹出是否删除的一个提示框，并且告诉用户目前有多少缓存
-  (void)deleteFileSize:(CGFloat)folderSize{
    if (folderSize > 0.01) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"缓存大小:%.2fM,是否清除?",folderSize] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView  show];
    }else{
        UIAlertView  * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"缓存已全部清理" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //彻底删除文件
        [self clearCacheWith:[self getPath]];
        _labelHuanChun.text = nil;
    }
}

-(void)clearCacheWith:(NSString *)path
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path])
    {
        NSArray * fileArray = [fileManager subpathsAtPath:path];
        for (NSString * fileName in fileArray)
        {
            //可以过滤掉特殊格式的文件
            if ([fileName hasSuffix:@".png"])
            {
                NSLog(@"不删除");
            }
            else
            {
                //获取每个子文件的路径
                NSString * filePath = [path stringByAppendingPathComponent:fileName];
                //移除指定路径下的文件
                [fileManager removeItemAtPath:filePath error:nil];
            }
        }
    }
}
#pragma mark - 按钮响应
- (void)swiChangeValue:(UISwitch *)swi{
    if (swi.tag == 2) {
    if (swi.on) {
        _darkView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        UIApplication * app = [UIApplication sharedApplication];
        AppDelegate * delegate = app.delegate;
        
        [delegate.window addSubview:_darkView];
        _darkView.userInteractionEnabled = NO;
    }else{
        [_darkView removeFromSuperview];
    }
    }
}
#pragma mark -  初始化数据
- (void)initData{
    self.logoArray = @[@"iconfont-iconfontaixinyizhan",@"iconfont-lajitong",@"iconfont-yejianmoshi",@"iconfont-zhengguiicon40",@"iconfont-guanyu"];
    self.titleArray = @[@"我的收藏",@"清理缓存",@"夜间模式",@"下载管理",@"关于我们"];
}
#pragma mark - 设置导航 -
- (void)resetNav{
    self.titleLabel.text =@"我的";
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
