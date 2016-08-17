//
//  ContentView.h
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EveryDayModel;
@interface ContentView : UIView


@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *littleLabel;

@property (nonatomic, strong) UILabel *descripLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *collectionCustom;

@property (nonatomic, strong) UILabel *shareCustom;

@property (nonatomic, strong) UILabel *cacheCustom;

@property (nonatomic, strong) UILabel *replyCustom;
//将scrollViewd切换的ID保存下来
//@property (nonatomic,copy)  NSString * dataId;
//将scrollViewd切换的model保存下来
@property (nonatomic,strong) EveryDayModel * dayModel;

- (instancetype)initWithFrame:(CGRect)frame Width:(CGFloat)width model:(EveryDayModel *)model collor:(UIColor *)collor;

- (void)setData:(EveryDayModel *)model;


@end
