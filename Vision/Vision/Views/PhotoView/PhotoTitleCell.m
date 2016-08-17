//
//  PhotoTitleCell.m
//  Vision
//
//  Created by QianFeng on 16/6/15.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "PhotoTitleCell.h"

@implementation PhotoTitleCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [FactoryUI createLabelWithFrame:CGRectMake(0, 0, (kWidth - 40) / 3, 30) text:nil textColor:[UIColor whiteColor] backgroundColor:[UIColor redColor] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

@end
