//
//  CommonTViewController.m
//  Vision
//
//  Created by QianFeng on 16/6/29.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "CommonTViewController.h"
#import "EveryDayCell.h"
#import "EveryDayModel.h"
#import "ContentScrollView.h"
#import "ContentView.h"
#import "EveryDetailView.h"
#import "CustomView.h"
#import "ImageContentView.h"
#import "KRVideoPlayerController.h"
#import "UIViewController+MMDrawerController.h"

#define URLL @"http://baobab.wandoujia.com/api/v3/videos?&categoryId=12&num=20"
@interface SDWebImageManager (cache)

- (BOOL)memoryCachedImageExistsForURL:(NSURL *)url;

@end

@implementation SDWebImageManager (cache)

- (BOOL)memoryCachedImageExistsForURL:(NSURL *)url {
    NSString *key = [self cacheKeyForURL:url];
    return ([self.imageCache imageFromMemoryCacheForKey:key] != nil) ?  YES : NO;
}

@end

@interface CommonTViewController (){
    int _page;
}
@property (nonatomic,strong) NSMutableDictionary *selectDic;

@property (nonatomic,strong) NSMutableArray *dateArray;
@property (nonatomic,strong) KRVideoPlayerController * videoController;
@end

@implementation CommonTViewController
#pragma mark - 数据解析
- (void)jsonSelection{
    NSString *url= [[NSString alloc]init];
    if (self.CategoryURL != nil) {
        url = [NSString stringWithFormat:CATEGORYURLL,self.CategoryURL,_page * 10];
    }else if (self.SenegalURL != nil){
        url = [NSString stringWithFormat:SENIORITY,self.SenegalURL];
    }
    
    //NSLog(@"-------%@",url);
    
    [LORequestManger GET:url success:^(id response) {
        //当下拉加载更多的时候需要清除掉数组中的数据，要不然就是直接加在数据后面
        if (_page != 1) {
            [self.dateArray removeAllObjects];
        }
        
        NSDictionary *Dic = (NSDictionary *)response;
        //NSLog(@"%@",Dic);
        NSArray *array = Dic[@"itemList"];
        
        for (NSDictionary *dic in array) {
            
            NSDictionary *arr = dic[@"data"];
            EveryDayModel *model = [[EveryDayModel alloc]init];
            [model setValuesForKeysWithDictionary:arr];
            model.collectionCount = arr[@"consumption"][@"collectionCount"];
            model.replyCount = arr[@"consumption"][@"replyCount"];
            model.shareCount = arr[@"consumption"][@"shareCount"];
            
            model.coverBlurred = arr[@"cover"][@"blurred"];
            model.coverForDetail = arr[@"cover"][@"detail"];
            
            [self.dateArray addObject:model];
        }
        
        if (_page == 1) {
            [self.tableView.header endRefreshing];
        } else {
            [self.tableView.footer endRefreshing];
        }
        //NSLog(@"%@",self.dateArray);
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dateArray = [[NSMutableArray alloc]init];
    [self resetNav];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[EveryDayCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     [self createRefresh];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"--------%ld",self.dateArray.count);
    return self.dateArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EveryDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 250;
    
}
//添加每个cell出现时的3D动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(EveryDayCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //EveryDayModel *model = self.selectDic[self.dateArray[indexPath.section]][indexPath.row];
    
    
    EveryDayModel * model = self.dateArray[indexPath.row];
    
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
    
    //_array = _selectDic[_dateArray[indexPath.section]];
    _array = _dateArray;
    _currentIndexPath = indexPath;
    
    EveryDayCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
    CGRect rect = [cell convertRect:cell.bounds toView:nil];
    CGFloat y = rect.origin.y;
    
#pragma mark - 排行对应到相应的button下 -
    //进行判断如果是_SenegalNum存在的时候，就用第一个方法，不存在就使用默认使用第二种方法
    if (self.SenegalNum) {
        _everyDetail = [[EveryDetailView alloc] initWithFrame:CGRectMake(kWidth * (_SenegalNum - 10), 0, kWidth, kHeight) imageArray:_array index:indexPath.row];
    }else{
    _everyDetail = [[EveryDetailView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) imageArray:_array index:indexPath.row];
    }
    _everyDetail.offsetY = y;
    _everyDetail.animationTrans = cell.picture.transform;
    _everyDetail.animationView.picture.image = cell.picture.image;
    
    _everyDetail.scrollView.delegate = self;
    
    [[self.tableView superview] addSubview:_everyDetail];
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
    
    [self playVideoWithURL:[NSURL URLWithString:model.playUrl]];
}
#pragma mark - 视频播放 -
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


#pragma mark - 设置导航
- (void)resetNav{
    self.title = @"详情";
    self.navigationController.navigationBar.barTintColor = RGB(242, 242, 242, 1);
    self.leftButton = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 44, 44) title:nil titleColor:nil backgroundColor:nil type:UIButtonTypeCustom target:self selector:@selector(buttonClick)];
    [self.leftButton setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
}
- (void)buttonClick{
        [self.navigationController popViewControllerAnimated:YES];
}

@end
