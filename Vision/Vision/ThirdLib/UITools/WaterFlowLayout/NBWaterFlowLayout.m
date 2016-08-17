//
//  NBWaterFlowLayout.m
//  Lesson_UI_19
//
//  Created by 杨阳 on 14/10/16.
//  Copyright (c) 2014年 yangyang. All rights reserved.
//

#import "NBWaterFlowLayout.h"

@interface NBWaterFlowLayout ()

@property (nonatomic, assign) NSUInteger numberOfItems;//item的数量
@property (nonatomic, assign) CGFloat interitemSpacing;//item的列间距
@property (nonatomic, retain) NSMutableArray *columnHeights;//用来保存每列的总高度的数组
@property (nonatomic, retain) NSMutableArray *itemAttributes;//用来保存最终计算出的每个item的数据的数组（数据保存在layoutAttribut对象的各个属性中）

- (NSInteger)_indexForLongestColumn;//最长列在columnHeights数组中的下标
- (NSInteger)_indexForShortestColumn;//最短列在columnHeights数组中的下标
- (void)_calculateItemPosition;//计算每个item的最终位置，用于布局
@end
@implementation NBWaterFlowLayout

#pragma mark - Lazy Loading Methods -

- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        self.columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)itemAttributes{
    if (!_itemAttributes) {
        self.itemAttributes = [NSMutableArray array];
    }
    return _itemAttributes;
}

- (void)dealloc{
    [_itemAttributes release];
    [_columnHeights release];
    [super dealloc];
}

- (NSInteger)_indexForLongestColumn{
    NSInteger index = 0;
    CGFloat longestHeight = 0;
    for (NSInteger i = 0; i < self.columnHeights.count; i++) {
        CGFloat currentHeight = [self.columnHeights[i] floatValue];
        if (currentHeight > longestHeight) {
            longestHeight = currentHeight;
            index = i;
        }
    }
    return index;
}

- (NSInteger)_indexForShortestColumn{
    NSInteger index = 0;
    CGFloat shortestHeight = CGFLOAT_MAX;//浮点型最大值
    for (NSInteger i = 0; i < self.columnHeights.count; i++) {
        CGFloat currentHeight = [self.columnHeights[i] floatValue];
        if (currentHeight < shortestHeight) {
            shortestHeight = currentHeight;
            index = i;
        }
    }
    return index;
}

- (void)_calculateItemPosition{
    //通过collectionView获取item的数量
    self.numberOfItems = [self.collectionView numberOfItemsInSection:0];
    //计算出内容视图的有效宽度
    CGFloat contentWidth = self.collectionView.frame.size.width - self.sectionInsets.left - self.sectionInsets.right;
    //计算item的列间距
    self.interitemSpacing = (contentWidth - self.numberOfColumns * self.itemSize.width) / (self.numberOfColumns - 1);
    //对计算结果向下取整
    self.interitemSpacing = floorf(self.interitemSpacing);
    
    for (NSInteger i = 0; i < self.numberOfColumns; i++) {
        //给每个列高设置默认
        self.columnHeights[i] = @(self.sectionInsets.top);
    }
    
    //根据item的数量来计算item的大小位置，以及所存在的列
    for (NSInteger i = 0; i < self.numberOfItems; i++) {
        //为每一个item创建对应indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        CGFloat itemHeigth = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:waterFlowLayout:heightForItemAtIndexPath:)]) {
            //通过代理对象实现的协议方法来获取每一个item最终的高度
            itemHeigth = [self.delegate collectionView:self.collectionView waterFlowLayout:self heightForItemAtIndexPath:indexPath];
        }
        
        //根据方法获取最短的列的下标
        NSInteger shortestColumnIndex = [self _indexForShortestColumn];
        CGFloat delta_x = self.sectionInsets.left + (self.itemSize.width + self.interitemSpacing) * shortestColumnIndex;
        CGFloat delta_y = [self.columnHeights[shortestColumnIndex] floatValue];
        //保存在我们创建的专门用于保存布局的item的相关属性的layoutAttributes对象中
        UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        //为layoutAttributes的frame属性赋值
        layoutAttributes.frame = CGRectMake(delta_x, delta_y, self.itemSize.width, itemHeigth);
        //将得到的layoutAttributes放入对应的数组中
        [self.itemAttributes addObject:layoutAttributes];
        //需要更新最短列的高度
        self.columnHeights[shortestColumnIndex] = @(delta_y + self.interitemSpacing + itemHeigth);
        
    }
}

- (void)prepareLayout{
    [super prepareLayout];
    [self _calculateItemPosition];
}

- (CGSize)collectionViewContentSize{
    //声明contentSize
    CGSize contentSize = self.collectionView.frame.size;
    //获取最长列的下标得到最长列的高度
    NSInteger longestColumnIndex = [self _indexForLongestColumn];
    //从列长数组中获取最长列高度
    CGFloat longestHeigth = [self.columnHeights[longestColumnIndex] floatValue];
    longestHeigth = longestHeigth - self.interitemSpacing + self.sectionInsets.bottom;
    contentSize.height = longestHeigth;
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.itemAttributes[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.itemAttributes;
}


@end
