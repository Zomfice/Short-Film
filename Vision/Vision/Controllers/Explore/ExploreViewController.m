//
//  ExploreViewController.m
//  Vision
//
//  Created by QianFeng on 16/6/28.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "ExploreViewController.h"
#import "ExploreModel.h"
#import "RGCardViewLayout.h"
#import "RGCollectionViewCell.h"
#import "KRVideoPlayerController.h"
#define URL @"http://baobab.wandoujia.com/api/v3/recommend?&u=6a0ff09bc84f4498dc41644083ce210c926eba7f&num=40"

@interface ExploreViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UICollectionView * _collectionView;
    NSMutableArray * _dataArray;
    NSMutableArray * _sectionArray;
    UIImageView * _imageView;
    UIImageView * _backGroundImg;
   
}
@property (nonatomic,strong)KRVideoPlayerController * videoController;
@property (nonatomic,strong)NSIndexPath * currentIndexPath;
@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _sectionArray = [[NSMutableArray alloc]init];
    [self resetNav];
    [self getData];
    [self createUI];
}

#pragma mark - 获取数据 -
- (void)getData{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSArray * arr = responseObject[@"itemList"];
        for (NSDictionary * dic in arr) {
            NSDictionary * data = dic[@"data"];
            ExploreModel * model = [[ExploreModel alloc]init];
            [model setValuesForKeysWithDictionary:data];
            //NSLog(@"%@%@",model.title,model.cover);
            [_dataArray addObject:model];
            
        }
        //NSLog(@"%@",_dataArray);
        
        for (ExploreModel * model in _dataArray) {
            
            NSArray * arr = @[model];
            //NSLog(@"----%@",arr);
            [_sectionArray addObject:arr];
            // NSLog(@"%@%@",model.title,model.cover);
        }
        
        [_collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}
- (void)createUI{
    
    RGCardViewLayout * flowLayout = [[RGCardViewLayout alloc]init];
    //flowLayout.itemSize = CGSizeMake(WIDTH - 20, 200);
    
    
    _backGroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _backGroundImg.image = [UIImage imageNamed:@"welcome3"];
    //_backGroundImg sd_setImageWithURL:[NSURL URLWithString:]
    [self.view addSubview:_backGroundImg];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, -64,kWidth,kHeight) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    /*
     //添加底部的收藏按钮
     _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qf"]];
     _imageView.frame = CGRectMake(WIDTH / 2 - 15, HEIGHT - 50, 30, 30);
     [self.view addSubview:_imageView];
     */
    
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"RGCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
}

#pragma mark - 实现collectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //NSLog(@"-----%ld",_dataArray.count);
    return _sectionArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //return [_dataArray[section] count];
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RGCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    ExploreModel * model = _sectionArray[indexPath.section][indexPath.row];
    
    //NSLog(@"%@%@",model.title,model.cover);
    if (_currentIndexPath) {
        _currentIndexPath = nil;
    }
    _currentIndexPath =indexPath;
    //    cell.frame = CGRectMake(38, 92,WIDTH - 38 * 2, HEIGHT - 92 * 2);
    cell.layer.cornerRadius = 15;
    //[self configureCell:cell withIndexPath:indexPath];
    
    [_backGroundImg sd_setImageWithURL:[NSURL URLWithString:model.cover[@"blurred"]]];
    
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover[@"feed"]]];
    cell.descriptionView.text = model.descriptionL;
    cell.categoryView.text = model.category;
    cell.title.text = model.title;
    
    UITapGestureRecognizer *gesTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPlay)];
    [cell.contentView addGestureRecognizer:gesTap];
    
    return cell;
}
- (void)tapPlay{
    /**
     *  此处有bug正方向滑动的时候没有问题，但是倒着滑动的时候就会出现上一个cell的信息，没有及时更新信息
     */
    //NSLog(@"点我啊");
    ExploreModel * model = _sectionArray[_currentIndexPath.section][_currentIndexPath.row];
    //NSLog(@"---------%@ %@",model.title,model.category);
    NSLog(@"%@",model.playUrl);
    [self playVideoWithURL:[NSURL  URLWithString:model.playUrl]];
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
#pragma mark - 设置导航
- (void)resetNav{
    self.titleLabel.text = @"探索";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
