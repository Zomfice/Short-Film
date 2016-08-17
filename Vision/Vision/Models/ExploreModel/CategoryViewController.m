//
//  CategoryViewController.m
//  Vision
//
//  Created by QianFeng on 16/6/29.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryModel.h"
#import "CategoryCollectionViewCell.h"
#define CATEGORYURL @"http://baobab.wandoujia.com/api/v3/discovery"
#import "NBWaterFlowLayout.h"
#import "CommonTViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface CategoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateWaterFlowLayout>{
    NSMutableArray * _dataArray;
    UICollectionView * _collectionView;
}

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    [self setNav];
    [self getData];
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark - 创建UI -
- (void)createUI{
    NBWaterFlowLayout *  flowlayout = [[NBWaterFlowLayout alloc]init];
    flowlayout.itemSize =  CGSizeMake((kWidth -  30)/2, 180);
    flowlayout.numberOfColumns = 2;
    flowlayout.delegate = self;
    flowlayout.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight- 50) collectionViewLayout:flowlayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
}
#pragma mark - 实现代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.layer.cornerRadius = 15;
    CategoryModel * model = _dataArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    cell.title.text = model.title;
    return cell;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView waterFlowLayout:(NBWaterFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CommonTViewController * DetailVC = [[CommonTViewController alloc]init];
    self.tabBarController.tabBar.hidden = YES;
    
    CategoryModel * model = _dataArray[indexPath.row];
    DetailVC.CategoryURL = model.idd;
    [self.navigationController pushViewController:DetailVC animated:YES];
}
#pragma mark - 获取数据 -
- (void)getData{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:CATEGORYURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //NSLog(@"%@",responseObject);
        NSArray * arr = responseObject[@"itemList"];
        for (int i = 4; i < arr.count; i++) {
            NSDictionary * dic = arr[i][@"data"];
            //NSLog(@"-----%@",dic);
            CategoryModel * model = [[CategoryModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
//        for (CategoryModel *model in _dataArray) {
//            NSLog(@"%@  %@  %@",model.title,model.image,model.idd);
//        }
        [_collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark  - 设置导航 -
- (void)setNav{
//    [self.leftButton setImage:[UIImage imageNamed:@"icon_function"] forState:UIControlStateNormal];
//    [self addLeftTarget:@selector(buttonClick)];
    self.titleLabel.text = @"分类";
}
//返回事件
//- (void)buttonClick{
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//}

/**
 实现tableView向上滚动会隐藏navgationbar,向下显示navgationbar
 */

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (velocity.y>0.0) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.navigationController setNavigationBarHidden:YES animated:YES];
//            self.navigationController.navigationBarHidden = YES;
        }];
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self.navigationController setNavigationBarHidden:NO animated:YES];
//            self.navigationController.navigationBarHidden = NO;
        }];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
