//
//  PhotoCell.m
//  Vision
//
//  Created by QianFeng on 16/6/15.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell ()

@property (nonatomic,strong) PhotoModel *model;

@end

@implementation PhotoCell


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    _imageView = [FactoryUI createImageViewWithFrame:CGRectMake(0, 0, self.bounds.size.width, 150) imageName:nil];
    [self.contentView addSubview:_imageView];
}
- (void)refreshUI:(PhotoModel *)model{
    _model =  model;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
}
@end
