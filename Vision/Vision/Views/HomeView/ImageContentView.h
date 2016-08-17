//
//  ImageContentView.h
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentView;
@class EveryDayModel;
@interface ImageContentView : UIView

@property (nonatomic, strong) UIImageView *picture;

- (instancetype)initWithFrame:(CGRect)frame Width:(CGFloat)width model:(EveryDayModel *)model collor:(UIColor *)collor;

- (void)imageOffset;

@end
