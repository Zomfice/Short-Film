//
//  ContentScrollView.h
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageContentView;
@class ContentScrollView;

@protocol ContentScrollViewDelegate <UIScrollViewDelegate>

- (void)headerScroll:(ContentScrollView *)scroll didSelectItemAtIndex:(NSInteger)index;
- (void)headerScroll:(ContentScrollView *)scroll didClose:(BOOL)close;

@end

@interface ContentScrollView : UIScrollView

@property (nonatomic ,assign ,readonly) NSInteger currentIndex;

- (void)setCurrentIndex:(NSInteger)currentIndex;

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray index:(NSInteger)index;

@end
