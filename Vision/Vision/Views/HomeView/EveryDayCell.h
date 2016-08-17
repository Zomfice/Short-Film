//
//  EveryDayCell.h
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EveryDayModel;
@interface EveryDayCell : UITableViewCell

@property (nonatomic, strong) UIImageView *picture;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *littleLabel;

@property (nonatomic, strong) UIView *coverview;

@property (nonatomic, strong) EveryDayModel *model;

- (CGFloat)cellOffset;

@end
