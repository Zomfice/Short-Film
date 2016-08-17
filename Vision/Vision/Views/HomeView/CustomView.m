//
//  CustomView.m
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView


- (instancetype)initWithFrame:(CGRect)frame Width:(CGFloat)width LabelString:(id)labelString collor:(UIColor *)collor{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CGFloat totalWidth = self.frame.size.width;
        CGFloat totalHeight = self.frame.size.height;
        
        //NSLog(@"%f--%f",totalWidth,totalHeight);
        
//        _button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
//        _button.frame = CGRectMake(0, 0, width, totalHeight);
        
//        _button.tintColor = [UIColor redColor];

//        [_button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_button];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(width, 0, totalWidth - width, totalHeight)];
        
        _label.textColor = collor;
        
        NSString *string = [NSString stringWithFormat:@"%@",labelString];
        
        _label.text = string;
        
        //NSLog(@"---++---%@",string);
        
        _label.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:_label];
        
    }
    return self;
}
- (void)click{
//    NSLog(@"sowsdfnadfafda");
}
- (void)setTitle:(NSString *)title {
    //NSLog(@"+++%@",title);
    self.label.text =[NSString stringWithFormat:@"%@",title];
}

- (void)setColor:(UIColor *)color {
    
    self.button.tintColor = color;
    self.label.textColor = color;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
