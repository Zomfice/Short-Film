//
//  FilmDetailViewController.m
//  Vision
//
//  Created by QianFeng on 16/7/4.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "FilmDetailViewController.h"
#import "FilmModel.h"
#import "KRVideoPlayerController.h"
#import "DBManager.h"
/**
 *  此界面的收藏下载依赖于数据库DBManager.h的创建，如果想要实现下载和收藏功能，需要重新创建DBmanager文件，同时需要修改存入表中的数据的值，这样就可以实现下载和收藏的功能同时实现
 
 */
@interface FilmDetailViewController ()

@property (nonatomic,strong) UIImageView * imageViewL;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIView * lineView;

@property (nonatomic,strong) UILabel * categoryLabel;

@property (nonatomic,strong) UILabel * descripLabel;

@property (nonatomic,strong) KRVideoPlayerController * videoController;
@end

@implementation FilmDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    //NSLog(@"-----%@",self.model.descriptionL);
    [self addTap];
    
    
}
- (void)createUI{
    _imageViewL = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth)];
    [self.view addSubview:_imageViewL];
    _imageViewL.contentMode = UIViewContentModeScaleAspectFill;
    [_imageViewL sd_setImageWithURL:[NSURL URLWithString:self.modelF.adTrack]];
    
//    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,kWidth +20, 300, 30)];
    _titleLabel = [FactoryUI createLabelWithFrame:CGRectMake(15, kWidth + 20, 300, 30) text:nil textColor:RGB(50, 50, 50, 1) backgroundColor:nil font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft];
    
    [self.view addSubview:_titleLabel];
    _titleLabel.text = self.modelF.title;
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(15, _titleLabel.frame.origin.y + 5 + _titleLabel.frame.size.height, _titleLabel.frame.size.width - 30, 1)];
    _lineView.backgroundColor = RGB(161, 161, 161, 161);
    [self.view addSubview:_lineView];
    

    _categoryLabel = [FactoryUI createLabelWithFrame:CGRectMake(15, _lineView.frame.origin.y + 5 + _lineView.frame.size.height, kWidth - 30, 20) text:nil textColor:RGB(196, 196, 196, 1) backgroundColor:nil font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:_categoryLabel];
    
    _categoryLabel.text = self.modelF.video_cate;
    
    _descripLabel = [FactoryUI createLabelWithFrame:CGRectMake(15, _categoryLabel.frame.origin.y + 5 + _categoryLabel.frame.size.height, kWidth - 30, 90) text:nil textColor:RGB(149, 149, 149, 1) backgroundColor:nil font:[UIFont  systemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    _descripLabel.numberOfLines = 0;
    [self.view addSubview:_descripLabel];
    _descripLabel.text = self.modelF.descriptionL;
    //创建底部barButton
    [self createBarViewButton];
    
    //底部区分bar的线条
    UIView * barLineView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight - 41, kWidth, 1)];
    barLineView.backgroundColor = RGB(221, 221, 222, 1);
    [self.view addSubview:barLineView];
    
    
    UIImageView *playImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"video-play@3x"]];
    playImage.frame = CGRectMake(0, 0, 80, 80);
    playImage.center = _imageViewL.center;
    [self.view addSubview:playImage];
    
    UITapGestureRecognizer * panTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playPanAction)];
    playImage.userInteractionEnabled = YES;
    [playImage addGestureRecognizer:panTap];
 }
- (void)playPanAction{
    //NSLog(@"点我了");
    [self playVideoWithURL:[NSURL URLWithString:self.modelF.playUrl]];
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
#pragma mark - 创建底部的BarView
- (void)createBarViewButton{
    //创建底部的bar
    UIView * barView = [FactoryUI createViewWithFrame:CGRectMake(0, kHeight- 40, kWidth, 30)];
    NSArray * selectedImageArray = @[@"filmback",@"iconfont-iconfontshoucang",@"playcount",@"share"];
    NSString *collectCount = [NSString stringWithFormat:@"%@",self.modelF.collectionCount];
    NSString * playcount = [NSString stringWithFormat:@"%@",self.modelF.playCount];
    NSArray * buttonTitle = @[@"",collectCount,playcount,@"分享"];
    
    for (int i = 0; i < 4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * selectImage = [UIImage imageNamed:selectedImageArray[i]];
        selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImageView * imageV = [[UIImageView alloc]initWithImage:selectImage];
        imageV.frame = CGRectMake(20,10,20,20);
        imageV.tag = 100 + i;
        [button addSubview:imageV];
        
        UILabel * btnLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.size.width + imageV.frame.origin.x + 5, 8, kWidth / 4 - 35, 30)];
        btnLabel.text = buttonTitle[i];
        btnLabel.font = [UIFont systemFontOfSize:13];
        
        
        [button addSubview:btnLabel];
        
        button.frame = CGRectMake(i * kWidth / 4, 0, kWidth / 4, 30) ;
        [barView addSubview:button];
        
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:barView];
}
#pragma  mark - button相应事件
- (void)buttonClick:(UIButton *)button{
    
    if (button.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(button.tag == 101){
        
    }else if (button.tag == 102){
//        NSLog(@"下载");
        [self playVideoWithURL:[NSURL URLWithString:self.modelF.playUrl]];
    }else if (button.tag == 103){
//        NSLog(@"分享");
        
    }
}


#pragma mark - 添加手势
- (void)addTap{
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipe];
}
- (void)panAction:(UITapGestureRecognizer *)swipe{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
