//
//  HomeViewController.h
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EveryDetailView;

@interface HomeViewController : UITableViewController

@property (nonatomic, strong) EveryDetailView *everyDetail;

@property (nonatomic, strong) UIImageView *BlurredView;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;
//左按钮
@property (nonatomic,strong) UIButton * leftButton;

@end
