//
//  HeaderView.h
//  Vision
//
//  Created by QianFeng on 16/6/14.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <UIKit/UIKit.h>

//返回分类名称
typedef void(^HeaderPage)(NSString *headCategory);

@interface HeaderView : UIView<UITableViewDataSource,UITableViewDelegate>{
    UITableView * _tableView;
}

//Block成员
@property (nonatomic,copy) HeaderPage headPage;
//分类数组
@property (nonatomic,strong)NSArray * dataArray;
//创建View
- (instancetype)initWithFrame:(CGRect)frame Width:(CGFloat)Width Color:(UIColor *)Color;

@end
