//
//  MyTabBarController.m
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "MyTabBarController.h"
#import "HomeViewController.h"
//#import "ReadViewController.h"
#import "CategoryViewController.h"
//#import "PhotoViewController.h"
#import "FilmViewController.h"
//#import "MyViewController.h"
#import "SeniorityViewController.h"
#import "ExploreViewController.h"
@interface MyTabBarController ()<UITabBarDelegate>

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewControllers];
    [self createTabBarItem];
}

- (void)createViewControllers{
    //首页
    HomeViewController * homeVC = [[HomeViewController alloc]initWithStyle:UITableViewStyleGrouped];
    UINavigationController * homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    homeNav.navigationBar.translucent = NO;
    
    //分类
    CategoryViewController * categoryVC = [[CategoryViewController alloc]init];
    UINavigationController  * cateNav = [[UINavigationController alloc]initWithRootViewController:categoryVC];
    
    
    //图片
    FilmViewController * photoVC = [[FilmViewController alloc]init];
//    UINavigationController *photoNav =  [[UINavigationController alloc]initWithRootViewController:photoVC];
    //我的
    SeniorityViewController *myVC = [[SeniorityViewController alloc]init];
    UINavigationController  *myNav = [[UINavigationController alloc]initWithRootViewController:myVC];
    
    //探索
    ExploreViewController * exploreVC = [[ExploreViewController alloc]init];
    UINavigationController * exploreNav = [[UINavigationController alloc]initWithRootViewController:exploreVC];
    
    //self.viewControllers = @[homeNav,cateNav,photoVC,myNav,exploreNav];
    self.viewControllers = @[homeNav,cateNav,myNav];
}
- (void)createTabBarItem{
    //未选中的图片
    /*NSArray * unselectedImageArray = @[@"home_normal@2x",@"read_normal@2x",@"video_normal@2x",@"my_normal@2x",@"photo_normal@2x"];
    //选中的图片
    NSArray * selectedImageArray = @[@"home_selected@2x",@"read_selected@2x",@"video_selected@2x",@"my_selected@2x",@"photo_selected@2x"];
    //标题
    NSArray  * titleArray = @[@"首页",@"分类",@"视频",@"排行",@"精选"];*/
    NSArray * unselectedImageArray = @[@"home_normal@2x",@"read_normal@2x",@"video_normal@2x",@"my_normal@2x",@"photo_normal@2x"];
    //选中的图片
    NSArray * selectedImageArray = @[@"home_selected@2x",@"read_selected@2x",@"my_selected@2x"];
    //标题
    NSArray  * titleArray = @[@"首页",@"分类",@"排行"];
    for (int  i = 0; i < self.tabBar.items.count; i ++) {
        UIImage * unselectedImage = [UIImage imageNamed:unselectedImageArray[i]];
        unselectedImage = [unselectedImage  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage * selectedImage = [UIImage imageNamed:selectedImageArray[i]];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem  * item = self.tabBar.items[i];
        
        item = [item initWithTitle:titleArray[i] image:unselectedImage selectedImage:selectedImage];
    }
    
    
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(27, 153, 219, 1)} forState:UIControlStateSelected];
    
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
