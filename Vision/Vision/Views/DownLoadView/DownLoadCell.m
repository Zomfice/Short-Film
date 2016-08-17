//
//  DownLoadCell.m
//  Vision
//
//  Created by QianFeng on 16/7/3.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "DownLoadCell.h"
#import "TYDownLoadDataManager.h"
#import "TYDownloadUtility.h"
#import "KRVideoPlayerController.h"
@interface DownLoadCell ()<TYDownloadDelegate>

@property (nonatomic,strong) TYDownloadModel * downloadModel;
@property (nonatomic,strong) KRVideoPlayerController * videoController;
@end

//static NSString * const downloadUrl = @"http://baobab.wdjcdn.com/14661605676871080.mp4";

@implementation DownLoadCell



#pragma mark - 删除沙盒中的视频 -
- (void)deleteFileWithDownloadModel{
     TYDownLoadDataManager *manager = [TYDownLoadDataManager manager];
    [manager cancleWithDownloadModel:self.downloadModel];
    [manager deleteFileWithDownloadModel:_downloadModel];
    
//    if ([manager isDownloadCompletedWithDownloadModel:_downloadModel]) {
//        //NSLog(@"删除视频成功");
//        [manager deleteFileWithDownloadModel:_downloadModel];
//    }
}
#pragma mark - 点击下载的cell进行视频播放 -
- (void)play{
    //NSLog(@"下载本地的链接:%@",[NSURL fileURLWithPath:_downloadModel.filePath]);
     TYDownLoadDataManager *manager = [TYDownLoadDataManager manager];
    if ([manager isDownloadCompletedWithDownloadModel:_downloadModel]) {
        
        //NSLog(@"下载本地的链接:%@",[NSURL fileURLWithPath:_downloadModel.filePath]);
        [self playVideoWithURL:[NSURL fileURLWithPath:_downloadModel.filePath]];
        return;
    }
}
#pragma mark - 视频播放 -
- (void)playVideoWithURL:(NSURL *)url
{
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, -64, width, width*(9.0/16.0))];
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


#pragma mark - 设置代理
- (void)delet{
    [TYDownLoadDataManager manager].delegate = self;
}

- (void)refreshDowloadInfo
{
    // manager里面是否有这个model是正在下载
    _downloadModel = [[TYDownLoadDataManager manager] downLoadingModelForURLString:self.downloadUrl];
    if (_downloadModel) {
        [self startDownlaod];
        return;
    }
    
    // 没有正在下载的model 重新创建
    TYDownloadModel *model = [[TYDownloadModel alloc]initWithURLString:self.downloadUrl];
    TYDownloadProgress *progress = [[TYDownLoadDataManager manager]progessWithDownloadModel:model];
    
    self.progressLabel.text = [self detailTextForDownloadProgress:progress];
 
    self.progressView.progress = progress.progress;
    [self.downloadBtn setTitle:[[TYDownLoadDataManager manager] isDownloadCompletedWithDownloadModel:model] ? @"下载完成，重新下载":@"开始" forState:UIControlStateNormal];
    _downloadModel = model;
}
#pragma mark - 点击下载按钮
- (IBAction)download:(id)sender {
    
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
#pragma mark - 开始下载
- (void)startDownlaod
{
    TYDownLoadDataManager *manager = [TYDownLoadDataManager manager];
    __weak typeof(self) weakSelf = self;
    [manager startWithDownloadModel:_downloadModel progress:^(TYDownloadProgress *progress) {
        weakSelf.progressView.progress = progress.progress;
        weakSelf.progressLabel.text = [weakSelf detailTextForDownloadProgress:progress];
        
    } state:^(TYDownloadState state, NSString *filePath, NSError *error) {
        if (state == TYDownloadStateCompleted) {
            weakSelf.progressView.progress = 1.0;
            weakSelf.progressLabel.text = [NSString stringWithFormat:@"progress %.2f",weakSelf.progressView.progress];
        }
        
        [weakSelf.downloadBtn setTitle:[weakSelf stateTitleWithState:state] forState:UIControlStateNormal];
        
        //NSLog(@"state %ld error%@ filePath%@",state,error,filePath);
    }];
}
- (NSString *)stateTitleWithState:(TYDownloadState)state
{
    switch (state) {
        case TYDownloadStateReadying:
            return @"等待下载";
            break;
        case TYDownloadStateRunning:
            return @"暂停下载";
            break;
        case TYDownloadStateFailed:
            return @"下载失败";
            break;
        case TYDownloadStateCompleted:
            return @"下载完成，重新下载";
            break;
        default:
            return @"开始下载";
            break;
    }
}

- (NSString *)detailTextForDownloadProgress:(TYDownloadProgress *)progress
{
    NSString *fileSizeInUnits = [NSString stringWithFormat:@"%.2f %@",
                                 [TYDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesExpectedToWrite],
                                 [TYDownloadUtility calculateUnit:(unsigned long long)progress.totalBytesExpectedToWrite]];
    
    NSMutableString *detailLabelText = [NSMutableString stringWithFormat:@"大小: %@\n进度: %.2f %@ (%.2f%%)\n速度: %.2f %@/s\n预计时间: %d S",fileSizeInUnits,
                                        [TYDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesWritten],
                                        [TYDownloadUtility calculateUnit:(unsigned long long)progress.totalBytesWritten],progress.progress*100,
                                        [TYDownloadUtility calculateFileSizeInUnit:(unsigned long long) progress.speed],
                                        [TYDownloadUtility calculateUnit:(unsigned long long)progress.speed]
                                        ,progress.remainingTime];
    return detailLabelText;
}

#pragma mark - TYDownloadDelegate

- (void)downloadModel:(TYDownloadModel *)downloadModel didUpdateProgress:(TYDownloadProgress *)progress
{
    //NSLog(@"delegate progress %.3f",progress.progress);
}

- (void)downloadModel:(TYDownloadModel *)downloadModel didChangeState:(TYDownloadState)state filePath:(NSString *)filePath error:(NSError *)error
{
//    NSLog(@"-------------delegate state %ld error%@ filePath%@",state,error,filePath);
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
