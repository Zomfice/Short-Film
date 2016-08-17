//
//  HomeViewController.m
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "HomeViewController.h"
#import "EveryDayCell.h"
#import "EveryDayModel.h"
#import "KRVideoPlayerController.h"
#import "ContentScrollView.h"
#import "ContentView.h"
#import "EveryDetailView.h"
#import "CustomView.h"
#import "ImageContentView.h"
#import "UIViewController+MMDrawerController.h"


@interface SDWebImageManager (cache)

- (BOOL)memoryCachedImageExistsForURL:(NSURL *)url;

@end

@implementation SDWebImageManager (cache)

- (BOOL)memoryCachedImageExistsForURL:(NSURL *)url {
    NSString *key = [self cacheKeyForURL:url];
    return ([self.imageCache imageFromMemoryCacheForKey:key] != nil) ?  YES : NO;
}

@end

@interface HomeViewController (){
    int _page;
}

@property (nonatomic,strong) NSMutableDictionary *selectDic;

@property (nonatomic,strong) NSMutableArray *dateArray;

@property (nonatomic,strong) KRVideoPlayerController *videoController;

@end

@implementation HomeViewController
#pragma mark - 数据解析

//懒加载
-  (NSMutableDictionary *)selectDic{
    if (!_selectDic) {
        _selectDic = [[NSMutableDictionary alloc]init];
    }
    return _selectDic;
}
- (NSMutableArray *)dataArray{
    if (_dateArray == nil) {
        _dateArray = [[NSMutableArray alloc]init];
    }
    return _dateArray;
}

#pragma mark - 请求数据
-(void)createRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.header beginRefreshing];
}

-(void)loadNewData
{
    _page = 1;
    [self jsonSelection];
}

-(void)loadMoreData
{
    _page ++;
    [self jsonSelection];
}
- (void)jsonSelection{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSDate *date = [NSDate date];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    
    NSString *url = [NSString stringWithFormat:kEveryDay,_page * 10,dateString];
    
    [LORequestManger GET:url success:^(id response) {
        if (_page != 1) {
            [self.dateArray removeAllObjects];
        }
        
        NSDictionary *Dic = (NSDictionary *)response;
        
        //NSLog(@"%@",Dic);
        
        NSArray *array = Dic[@"dailyList"];
        
        for (NSDictionary *dic in array) {
            
            NSMutableArray *selectArray = [NSMutableArray array];
            
            NSArray *arr = dic[@"videoList"];
            
            for (NSDictionary *dic1 in arr) {
                
                EveryDayModel *model = [[EveryDayModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dic1];
                
                model.collectionCount = dic1[@"consumption"][@"collectionCount"];
                model.replyCount = dic1[@"consumption"][@"replyCount"];
                model.shareCount = dic1[@"consumption"][@"shareCount"];
                
                [selectArray addObject:model];
            }
            NSString *date = [[dic[@"date"] stringValue] substringToIndex:10];
            
            [self.selectDic setValue:selectArray forKey:date];
        }
        
        NSComparisonResult (^priceBlock)(NSString *, NSString *) = ^(NSString *string1, NSString *string2){
            
            NSInteger number1 = [string1 integerValue];
            NSInteger number2 = [string2 integerValue];
            
            if (number1 > number2) {
                return NSOrderedAscending;
            }else if(number1 < number2){
                return NSOrderedDescending;
            }else{
                return NSOrderedSame;
            }
            
        };
        
        self.dateArray = [[[self.selectDic allKeys] sortedArrayUsingComparator:priceBlock]mutableCopy];
        
        //NSLog(@"%ld",[self.dateArray count]);
        
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}
#pragma mark - 加载界面
- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //self.navigationController.navigationBarHidden = YES;
    [self resetNav];
    //[self jsonSelection];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView registerClass:[EveryDayCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self createRefresh];
}
//- (void)viewWillAppear:(BOOL)animated{
//    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tabar隐藏取消
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dateArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.selectDic[self.dateArray[section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EveryDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   
    
    return cell;
}


//头标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *string = self.dateArray[section];
    
    long long int date1 = (long long int)[string intValue];
    
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"MMdd"];
    
    NSString *dateString = [dateFormatter stringFromDate:date2];
    
    NSString *strin =  [NSString stringWithFormat:@"# %@",dateString];
    
    return strin;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 250;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
//添加每个cell出现时的3D动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(EveryDayCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    EveryDayModel *model = self.selectDic[self.dateArray[indexPath.section]][indexPath.row];
    
    if (![[SDWebImageManager sharedManager] memoryCachedImageExistsForURL:[NSURL URLWithString:model.coverForDetail]]) {
        
        CATransform3D rotation;//3D旋转
        
        rotation = CATransform3DMakeTranslation(0 ,50 ,20);
        //        rotation = CATransform3DMakeRotation( M_PI_4 , 0.0, 0.7, 0.4);
        //逆时针旋转
        
        rotation = CATransform3DScale(rotation, 0.9, .9, 1);
        
        rotation.m34 = 1.0/ -600;
        
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        
        cell.layer.transform = rotation;
        
        [UIView beginAnimations:@"rotation" context:NULL];
        //旋转时间
        [UIView setAnimationDuration:0.6];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];
    }
    
    [cell cellOffset];
    cell.model = model;
}
#pragma mark ---------- 单元格代理方法 ----------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showImageAtIndexPath:indexPath];
}

#pragma mark --------- 设置待播放界面 ----------

- (void)showImageAtIndexPath:(NSIndexPath *)indexPath{
    
    _array = _selectDic[_dateArray[indexPath.section]];
    _currentIndexPath = indexPath;
    
    EveryDayCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
    CGRect rect = [cell convertRect:cell.bounds toView:nil];
    CGFloat y = rect.origin.y;
    
    _everyDetail = [[EveryDetailView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) imageArray:_array index:indexPath.row];
    _everyDetail.offsetY = y;
    _everyDetail.animationTrans = cell.picture.transform;
    _everyDetail.animationView.picture.image = cell.picture.image;
    
    _everyDetail.scrollView.delegate = self;
    
    [[self.tableView superview] addSubview:_everyDetail];
    
    //解决抽屉手势冲突问题
    
    //添加轻扫手势
    UISwipeGestureRecognizer *Swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    
    _everyDetail.contentView.userInteractionEnabled = YES;
    
    Swipe.direction = UISwipeGestureRecognizerDirectionUp;
    
    
    [_everyDetail.contentView addGestureRecognizer:Swipe];
    
    //添加点击播放手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [_everyDetail.scrollView addGestureRecognizer:tap];
    
    [_everyDetail aminmationShow];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:_everyDetail.scrollView]) {
        
        for (ImageContentView *subView in scrollView.subviews) {
            
            if ([subView respondsToSelector:@selector(imageOffset)] ) {
                [subView imageOffset];
            }
        }
        
        CGFloat x = _everyDetail.scrollView.contentOffset.x;
        
        CGFloat off = ABS( ((int)x % (int)kWidth) - kWidth/2) /(kWidth/2) + .2;
        
        [UIView animateWithDuration:1.0 animations:^{
            _everyDetail.playView.alpha = off;
            _everyDetail.contentView.titleLabel.alpha = off + 0.3;
            _everyDetail.contentView.littleLabel.alpha = off + 0.3;
            _everyDetail.contentView.lineView.alpha = off + 0.3;
            _everyDetail.contentView.descripLabel.alpha = off + 0.3;
            _everyDetail.contentView.collectionCustom.alpha = off + 0.3;
            _everyDetail.contentView.shareCustom.alpha = off + 0.3;
            _everyDetail.contentView.cacheCustom.alpha = off + 0.3;
            _everyDetail.contentView.replyCustom.alpha = off + 0.3;
            
        }];
        
    } else {
        
        NSArray<EveryDayCell *> *array = [self.tableView visibleCells];
        
        [array enumerateObjectsUsingBlock:^(EveryDayCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [obj cellOffset];
        }];
        
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:_everyDetail.scrollView]) {
        
        int index = floor((_everyDetail.scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
        
        _everyDetail.scrollView.currentIndex = index;
        
        self.currentIndexPath = [NSIndexPath indexPathForRow:index inSection:self.currentIndexPath.section];
        
        [self.tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:(UITableViewScrollPositionMiddle) animated:NO];
        
        [self.tableView setNeedsDisplay];
        EveryDayCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPath];
        
        [cell cellOffset];
        
        CGRect rect = [cell convertRect:cell.bounds toView:nil];
        _everyDetail.animationTrans = cell.picture.transform;
        _everyDetail.offsetY = rect.origin.y;
        
        EveryDayModel *model = _array[index];
        
        [_everyDetail.contentView setData:model];
        
        [_everyDetail.animationView.picture setImageWithURL:[NSURL URLWithString: model.coverForDetail]];
        
    }
}

#pragma mark -------------- 平移手势触发事件 -----------

- (void)panAction:(UISwipeGestureRecognizer *)swipe{
    
    [_everyDetail animationDismissUsingCompeteBlock:^{
        //将视频移除
        [self.videoController dismiss];
        _everyDetail = nil;
        
    }];
}

#pragma mark -------------- 点击手势触发事件 -----------

- (void)tapAction{
    EveryDayModel *model = [_array objectAtIndex:self.currentIndexPath.row];
    self.tabBarController.tabBar.hidden = YES;
    
    [self playVideoWithURL:[NSURL URLWithString:model.playUrl]];
}
- (void)playVideoWithURL:(NSURL *)url
{
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
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



/**
 实现tableView向上滚动会隐藏navgationbar,向下显示navgationbar
 */

//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    if (velocity.y>0.0) {
//    [UIView animateWithDuration:0.3 animations:^{
////             self.navigationController.navigationBarHidden = YES;
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        }];
//       
//    }else{
//        [UIView animateWithDuration:0.3 animations:^{
////           self.navigationController.navigationBarHidden = NO;
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
//        }];
//        
//    }
//}
#pragma mark - 设置导航
- (void)resetNav{
    self.title = @"视野";
    self.navigationController.navigationBar.barTintColor = RGB(242, 242, 242, 1);
    self.leftButton = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 44, 44) title:nil titleColor:nil backgroundColor:nil type:UIButtonTypeCustom target:self selector:@selector(buttonClick)];
    [self.leftButton setImage:[UIImage imageNamed:@"icon_function"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
}
- (void)buttonClick{
    
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
