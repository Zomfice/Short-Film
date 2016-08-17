//
//  HeaderView.m
//  Vision
//
//  Created by QianFeng on 16/6/14.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView
#pragma mark - 重写init方法
- (instancetype)initWithFrame:(CGRect)frame Width:(CGFloat)Width Color:(UIColor *)Color{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = @[@"All",@"DaXiong",@"QiaoTun",@"HeiSi",@"QingXin",@"ZaHui"];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth - 20, 200) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
    }
    return self;
}
#pragma mark - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.tintColor = [UIColor whiteColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.headPage) {
        self.headPage(self.dataArray[indexPath.row]);
    }
    tableView.hidden = YES;
}
@end
