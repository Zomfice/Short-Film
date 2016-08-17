//
//  ImageContentView.m
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "ImageContentView.h"
#import "ContentView.h"
#import "EveryDayModel.h"
@implementation ImageContentView



- (instancetype)initWithFrame:(CGRect)frame Width:(CGFloat)width model:(EveryDayModel *)model collor:(UIColor *)collor{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.clipsToBounds = YES;
        //如果图片高度不加64会出现和cell的部分图片重叠出现，不能在ImagecontentView中完全显示图片
        _picture = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight / 1.7 + 64)];
        _picture.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:_picture];
        
        //        _contentView = [[ContentView alloc]initWithFrame:CGRectMake(0, _picture.frame.size.height, kWidth, kHeight - _picture.frame.size.height) Width:width model:model collor:collor];
        //        [_contentView sd_setImageWithURL:[NSURL URLWithString:model.coverBlurred] placeholderImage:nil];
        //        [self addSubview:_contentView];
        
    }
    return self;
}


- (void)imageOffset {
    
    CGRect centerToWindow = [self convertRect:self.bounds toView:nil];
    
    CGFloat centerX = CGRectGetMidX(centerToWindow);
    CGPoint windowCenter = self.window.center;
    
    CGFloat cellOffsetX = centerX - windowCenter.x;
    
    CGFloat offsetDig =  cellOffsetX / self.window.frame.size.height *2;
    
    CGAffineTransform transX = CGAffineTransformMakeTranslation(- offsetDig * kWidth * 0.7, 0);
    
    //    self.titleLabel.transform = transY;
    //    self.littleLabel.transform = transY;
    
    self.picture.transform = transX;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
