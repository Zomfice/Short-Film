//
//  StoryDetailViewController.h
//  Vision
//
//  Created by QianFeng on 16/6/14.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "RootViewController.h"
#import "ArticalModel.h"
@interface StoryDetailViewController : RootViewController
@property (nonatomic,strong) ArticalModel * model;
//title
@property (nonatomic,copy)NSString *titleString;
@end
