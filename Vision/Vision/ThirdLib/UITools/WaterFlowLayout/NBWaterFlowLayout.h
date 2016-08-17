//
//  NBWaterFlowLayout.h
//  Lesson_UI_19
//
//  Created by 杨阳 on 14/10/16.
//  Copyright (c) 2014年 yangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NBWaterFlowLayout;

@protocol UICollectionViewDelegateWaterFlowLayout <UICollectionViewDelegate>

- (CGFloat)collectionView:(UICollectionView *)collectionView
          waterFlowLayout:(NBWaterFlowLayout *)layout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NBWaterFlowLayout : UICollectionViewLayout

@property (nonatomic, assign) id<UICollectionViewDelegateWaterFlowLayout> delegate;

@property (nonatomic, assign) NSUInteger numberOfColumns;//瀑布流的列数
@property (nonatomic, assign) CGSize itemSize;//每一个item的大小
@property (nonatomic, assign) UIEdgeInsets sectionInsets;//分区的上下左右四个边距

@end
