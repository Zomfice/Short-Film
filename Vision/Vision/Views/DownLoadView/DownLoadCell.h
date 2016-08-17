//
//  DownLoadCell.h
//  Vision
//
//  Created by QianFeng on 16/7/3.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownLoadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (nonatomic,copy) NSString * downloadUrl;
- (void)refreshDowloadInfo;
- (void)delet;
- (void)play;
- (void)deleteFileWithDownloadModel;

@end
