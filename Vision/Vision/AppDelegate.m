//
//  AppDelegate.m
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarController.h"
//抽屉
#import "FLSideSlipViewController.h"
#import "MMDrawerController.h"

#import "GuidePageView.h"
#import "MyViewController.h"

@interface AppDelegate ()
//引导页
@property (nonatomic,strong)GuidePageView * guideView;
@property (nonatomic,strong) MyTabBarController  * myTabBar;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    //初始化页面
    //主页面
    self.myTabBar = [[MyTabBarController alloc]init];
    //左边抽屉
    MyViewController * myVC = [[MyViewController alloc]init];
    UINavigationController * myNav = [[UINavigationController alloc]initWithRootViewController:myVC];
    MMDrawerController * drawerVC = [[MMDrawerController alloc]initWithCenterViewController:self.myTabBar leftDrawerViewController:myNav];
    
    //设置打开和关闭手势
    drawerVC.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    drawerVC.closeDrawerGestureModeMask = MMOpenDrawerGestureModeNone;

    //设置左控制器显示的宽度
    drawerVC.maximumLeftDrawerWidth = kWidth -100;
    self.window.rootViewController = drawerVC;
    //引导页
    [self createGuidePage];
    return YES;
}

#pragma mark - 创建引导页
-(void)createGuidePage
{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isRuned"] boolValue])
    {
        NSArray * array = @[@"welcome2.png",
                            @"welcome6.png",
                            @"welcome7.png",
                            @"welcome4.png"];
        //创建引导页视图
        self.guideView = [[GuidePageView alloc]initWithFrame:self.window.bounds namesArray:array];
        [self.myTabBar.view addSubview:self.guideView];
        
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"isRuned"];
    }else
    {
        [self checkNetWorkState];
    }
    
    //点击进入首页
    [self.guideView.guideBtn addTarget:self action:@selector(beginExperience:) forControlEvents:UIControlEventTouchUpInside];
}
//跳转进入首页
- (void)beginExperience:(UIButton *)sender
{
    [self.guideView removeFromSuperview];
    [self checkNetWorkState];
}
#pragma mark - 检测网络状态
-(void)checkNetWorkState
{
    //创建一个用于测试的url
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    //判断不同的网络状态
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self createAlertView:@"您当前使用的是数据流量"];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [self createAlertView:@"您当前使用的是Wifi"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [self createAlertView:@"世界上最遥远的距离就是没网"];
                break;
            case AFNetworkReachabilityStatusUnknown:
                [self createAlertView:@"网络状况不明确"];
                break;
                
            default:
                break;
        }
    }];
    
}
//网络提示
-(void)createAlertView:(NSString *)message
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
