//
//  EveryDetailView.h
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentView;
@class ContentScrollView;
@class EveryDayCell;
@interface EveryDetailView : UIView

@property (nonatomic, strong) ContentView *contentView;

@property (nonatomic, strong) ContentScrollView *scrollView;

@property (nonatomic, strong)  EveryDayCell *animationView;


@property (nonatomic ,strong) UIImageView *playView;

@property (nonatomic ,assign) NSInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray index:(NSInteger)index;

@property (nonatomic ,assign) CGFloat offsetY;
@property (nonatomic ,assign) CGAffineTransform animationTrans;

- (void)aminmationShow;
- (void)animationDismissUsingCompeteBlock:(void (^)(void))complete;

@end
