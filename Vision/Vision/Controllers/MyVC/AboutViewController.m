//
//  AboutViewController.m
//  Vision
//
//  Created by QianFeng on 16/6/27.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "AboutViewController.h"

#import "QRCodeGenerator.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
    [self resetNav];
    [self createUI];
    [self createQR];
}

- (void)createUI{
    UIImageView *imageViewAbout = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - 40, self.view.center.y - 250, 80, 80)];
    imageViewAbout.image = [UIImage imageNamed:@"about_img"];
    imageViewAbout.layer.cornerRadius = 40;
    imageViewAbout.layer.masksToBounds = YES;
    [self.view addSubview:imageViewAbout];
    
    
    UILabel *label =  [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 80, self.view.center.y - 150, 150, 30)];
    label.numberOfLines = 1;
    label.text = @"视野是你对世界的渴望";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 30, kHeight - 100, 100, 30)];
    label2.text = @"当前版本";
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x -15, kHeight - 70, 100, 30)];
    label3.text = @"V1.0";
    [self.view addSubview:label3];
    
}

- (void)resetNav{
    self.navigationController.navigationBar.translucent = YES;
    [self.leftButton setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [self addLeftTarget:@selector(backButtonClick)];
    self.titleLabel.text = @"关于我们";
}
- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createQR{
    //生成二维码
    UIImageView * imageView = [FactoryUI createImageViewWithFrame:CGRectMake(0, 0, 150, 150) imageName:nil];
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    
    imageView.image = [QRCodeGenerator qrImageForString:@"http://blog.csdn.net/zomfice" imageSize:150];
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
