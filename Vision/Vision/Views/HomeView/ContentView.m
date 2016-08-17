//
//  ContentView.m
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "ContentView.h"
#import "EveryDayModel.h"

#import "DBManager.h"
#import "TYDownLoadDataManager.h"
#import "DownLoadViewController.h"

@interface ContentView ()
@property (nonatomic,strong) TYDownloadModel * downloadModel;

@end


@implementation ContentView


#pragma mark - UI布局
- (instancetype)initWithFrame:(CGRect)frame Width:(CGFloat)width model:(EveryDayModel *)model collor:(UIColor *)collor{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        //图
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        //标题
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, kWidth, 30)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = collor;
        [self addSubview:_titleLabel];
        //下划线
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(5, 35, 200, 1)];
        _lineView.backgroundColor = collor;
        [self addSubview:_lineView];
        //分类时间
        _littleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 46, kWidth, 20)];
        _littleLabel.textColor = collor;
        _littleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_littleLabel];
        //描述
        _descripLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 50, kWidth - 10, 90)];
        _descripLabel.font = [UIFont systemFontOfSize:14];

        _descripLabel.numberOfLines = 0;
        _descripLabel.textColor = collor;
        [self addSubview:_descripLabel];
        //下面下载分享按钮的垂直方向的起始
        CGFloat y = _descripLabel.frame.size.height + 55;
#pragma mark - 设置模糊图
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.coverForDetail]];
#pragma mark - 分享按钮
        UIButton * shareButton = [FactoryUI createButtonWithFrame:CGRectMake(kWidth - kWidth / 3 + 30, y + 5, 22, 22) title:nil titleColor:nil backgroundColor:nil type:UIButtonTypeCustom target:self selector:@selector(shareButtonClick:)];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateSelected];
        [self addSubview:shareButton];
        
        //分享数量
        _shareCustom = [[UILabel alloc]initWithFrame:CGRectMake(shareButton.frame.size.width + shareButton.frame.origin.x + 4, y + 5, 40, 30)];
        _shareCustom.text = [NSString stringWithFormat:@"%@",model.shareCount];
        _shareCustom.font =  [UIFont systemFontOfSize:14];
        _shareCustom.textColor = collor;
        [self addSubview:_shareCustom];
        
#pragma mark - 收藏功能
        //添加收藏按钮
        //收藏按钮
        UIButton * collectButton = [FactoryUI createButtonWithFrame:CGRectMake(30, y + 5, 22, 22) title:nil titleColor:nil backgroundColor:nil type:UIButtonTypeCustom target:self selector:@selector(collecButtonClick:)];
         [collectButton setBackgroundImage:[UIImage imageNamed:@"iconfont-iconfontshoucang"] forState:UIControlStateNormal];
        [collectButton setImage:[UIImage imageNamed:@"iconfont-iconfontshoucang-2"] forState:UIControlStateSelected];
        [self addSubview:collectButton];
        
        //收藏数量
        _collectionCustom = [[UILabel alloc]initWithFrame:CGRectMake(collectButton.frame.size.width + collectButton.frame.origin.x + 4, y + 5, 60, 30) ];
        _collectionCustom.text = [NSString stringWithFormat:@"%@",model.collectionCount];
        _collectionCustom.font =  [UIFont systemFontOfSize:14];
        _collectionCustom.textColor = collor;
        
        [self addSubview:_collectionCustom];
        
//        NSLog(@"hhaha%@",model.ID);
//        self.dataId = model.ID;
        //判断是否收藏过了
        DBManager * manager = [DBManager defaultManager];
        if ([manager isHasDataIDFromTable:self.dayModel.ID]) {
            collectButton.selected = YES;
            [collectButton setImage:[UIImage imageNamed:@"iconfont-iconfontshoucang-2"] forState:UIControlStateSelected];
        }
#pragma mark - 下载功能 -
        UIButton * downloadButton = [FactoryUI createButtonWithFrame:CGRectMake(kWidth / 3 + 40, y + 5, 22, 22) title:nil titleColor:nil backgroundColor:nil type:UIButtonTypeCustom target:self selector:@selector(downloadClick:)];
        [downloadButton setBackgroundImage:[UIImage imageNamed:@"download2_normal"] forState:UIControlStateNormal];
        [downloadButton setImage:[UIImage imageNamed:@"download2_select"] forState:UIControlStateSelected];
        [self addSubview:downloadButton];
        
        _cacheCustom = [FactoryUI createLabelWithFrame:CGRectMake(downloadButton.frame.size.width + downloadButton.frame.origin.x + 4, y + 5, 40, 30) text:@"缓存" textColor:collor backgroundColor:nil font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter];
        [self addSubview:_cacheCustom];
        

        
        DBManager * manager2 = [DBManager defaultManager2];
        if ([manager2 isHasDataIDFromTable:self.dayModel.ID]) {
            downloadButton.selected = YES;
            [collectButton setImage:[UIImage imageNamed:@"download2_select"] forState:UIControlStateSelected];
        }
        [self setData:model];
    }
    return self;
}
//收藏的响应方法
- (void)collecButtonClick:(UIButton *)button{
    //NSLog(@"点我啊%@",self.dayModel.ID);
    button.selected = YES;
    DBManager * manager = [DBManager defaultManager];
    if ([manager isHasDataIDFromTable:self.dayModel.ID])
    {
        //说明已经收藏过
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经收藏过" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
        //未曾收藏过,则插入一条数据
       [manager insertDataModel:self.dayModel];
        
    }
}
//下载的响应方法
#pragma mark - 下载按钮响应方法
- (void)downloadClick:(UIButton *)button{
    button.selected = YES;
    [self downLoadCollect];
    //代理
//    [self delegateL];
}
//开始下载
#pragma mark - 开始下载
- (void)startDownlaod
{
    TYDownLoadDataManager *manager = [TYDownLoadDataManager manager];
//    __weak typeof(self) weakSelf = self;
    [manager startWithDownloadModel:_downloadModel progress:^(TYDownloadProgress *progress) {
//        weakSelf.progressView.progress = progress.progress;
//        weakSelf.progressLabel.text = [weakSelf detailTextForDownloadProgress:progress];
        
    } state:^(TYDownloadState state, NSString *filePath, NSError *error) {
        if (state == TYDownloadStateCompleted) {
//            weakSelf.progressView.progress = 1.0;
//            weakSelf.progressLabel.text = [NSString stringWithFormat:@"progress %.2f",weakSelf.progressView.progress];
        }
//        
//        [weakSelf.downloadBtn setTitle:[weakSelf stateTitleWithState:state] forState:UIControlStateNormal];
//        
        //NSLog(@"state %ld error%@ filePath%@",state,error,filePath);
    }];
}


//下载状态的判断
- (void)downModelState{
    TYDownLoadDataManager *manager = [TYDownLoadDataManager manager];
    
    if (_downloadModel.state == TYDownloadStateReadying) {
        [manager cancleWithDownloadModel:_downloadModel];
        return;
    }
    if ([manager isDownloadCompletedWithDownloadModel:_downloadModel]) {
        [manager deleteFileWithDownloadModel:_downloadModel];
    }
    
    if (_downloadModel.state == TYDownloadStateRunning) {
        [manager suspendWithDownloadModel:_downloadModel];
        return;
    }
    [self startDownlaod];
}
- (void)refreshDowloadInfo{
    // manager里面是否有这个model是正在下载
    _downloadModel = [[TYDownLoadDataManager manager] downLoadingModelForURLString:self.dayModel.playUrl];
    if (_downloadModel) {
        [self startDownlaod];
        return;
    }
    // 没有正在下载的model 重新创建
    TYDownloadModel *model = [[TYDownloadModel alloc]initWithURLString:self.dayModel.playUrl];
    TYDownloadProgress *progress = [[TYDownLoadDataManager manager]progessWithDownloadModel:model];
    _downloadModel = model;

}

#pragma mark - down代理
//- (void)delegateL{
//    [TYDownLoadDataManager manager].delegate = self;
//}
//#pragma mark - TYDownloadDelegate
//- (void)downloadModel:(TYDownloadModel *)downloadModel didUpdateProgress:(TYDownloadProgress *)progress
//{
//    NSLog(@"delegate progress %.3f",progress.progress);
//}
//
//- (void)downloadModel:(TYDownloadModel *)downloadModel didChangeState:(TYDownloadState)state filePath:(NSString *)filePath error:(NSError *)error
//{
//    NSLog(@"delegate state %ld error%@ filePath%@",state,error,filePath);
//}
#pragma mark - download收藏
- (void)downLoadCollect{
    //下载类先收藏到本机
    DBManager * manager2 = [DBManager defaultManager2];
    if ([manager2 isHasDataIDFromTable:self.dayModel.ID])
    {
        //说明已经收藏过
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"正在下载，请到下载管理查看" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
        //未曾收藏过,则插入一条数据
        [manager2 insertDataModel:self.dayModel];
        [self refreshDowloadInfo];
        [self downModelState];
    }
}

#pragma mark - 数据取值 -
- (void)setData:(EveryDayModel *)model {
    
    self.titleLabel.text = model.title;
    self.descripLabel.text = model.descrip;
    
    
    self.collectionCustom.text = [NSString stringWithFormat:@"%@",model.collectionCount];
    self.shareCustom.text = [NSString stringWithFormat:@"%@",model.shareCount];
//    [self.shareCustom setTitle:model.shareCount];
//    [self.replyCustom setTitle:model.replyCount];
//    [self.collectionCustom setTitle:model.collectionCount];
    
    //scrollView切换的是否ID发生改变
//    self.dataId = model.ID;
    self.dayModel = model;
    
    NSInteger time = [model.duration integerValue];
    NSString *timeString = [NSString stringWithFormat:@"%02ld'%02ld''",time/60,time% 60];//显示的是音乐的总时间
    NSString *string = [NSString stringWithFormat:@"#%@ / %@",model.category, timeString];
    self.littleLabel.text = string;
    
    __weak typeof(self) weakSelf = self;
    
    //    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.coverBlurred]];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:model.coverBlurred] options:(SDWebImageRetryFailed) progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        if (image) {
            
            CABasicAnimation *contentsAnimation = [CABasicAnimation animationWithKeyPath:@"contents"];
            contentsAnimation.duration = 1.0f;
            contentsAnimation.fromValue = self.imageView.image ;
            contentsAnimation.toValue = image;
            
            contentsAnimation.removedOnCompletion = YES;
            contentsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [weakSelf.imageView.layer addAnimation:contentsAnimation forKey:nil];
            
            weakSelf.imageView.image = image;
            
        }
        
    }];
}
#pragma mark - 分享
- (void)shareButtonClick:(UIButton *)shareBtn{
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
