//
//  CustomViewController.h
//  ZBarDemo
//
//  Created by 杨阳 on 14/4/16.
//  Copyright (c) 2014年 yangyang. All rights reserved.
//

//二维码编译顺序
//Zbar编译
//需要添加AVFoundation  CoreMedia  CoreVideo QuartzCore libiconv


//示例代码
//扫描代码
//BOOL代表是否关闭二维码扫描，专门扫描条形码
//CustomViewController*vc=[[CustomViewController alloc]initWithIsQRCode:NO Block:^(NSString *result, BOOL isFinish) {
//    if (isFinish) {
//        NSLog(@"最后的结果%@",result);
//    }
//    
//}];

//[self presentViewController:vc animated:YES completion:nil];


//生成二维码
//拖拽libqrencode包进入工程，注意点copy
//添加头文件#import "QRCodeGenerator.h"
//imageView.image=[QRCodeGenerator qrImageForString:@"这个是什么" imageSize:imageView.bounds.size.width];

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZBarReaderController.h"

#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7

@interface CustomViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,ZBarReaderDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    UIImageView*_line;
}

@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, assign) BOOL isScanning;

@property (nonatomic,copy)void(^ScanResult)(NSString*result,BOOL isSucceed);
@property (nonatomic)BOOL isQRCode;


//初始化函数
-(id)initWithIsQRCode:(BOOL)isQRCode Block:(void(^)(NSString*,BOOL))a;

//正则表达式对扫描结果筛选
+(NSString*)zhengze:(NSString*)str;




@end
