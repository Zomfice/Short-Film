//
//  CommonTViewController.h
//  Vision
//
//  Created by QianFeng on 16/6/29.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EveryDetailView;

@interface CommonTViewController : UITableViewController

@property (nonatomic, strong) EveryDetailView *everyDetail;

@property (nonatomic, strong) UIImageView *BlurredView;
 
@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;
//左按钮
@property (nonatomic,strong) UIButton * leftButton;
@property (nonatomic,copy) NSString * CategoryURL;
//排行的类型:月排行
@property (nonatomic,copy) NSString * SenegalURL;
@property (nonatomic,assign) NSInteger SenegalNum;
- (void)jsonSelection;
-(void)createRefresh;
@end
