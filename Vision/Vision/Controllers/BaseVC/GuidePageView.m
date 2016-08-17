//
//  GuidePageView.m
//  Vision
//
//  Created by QianFeng on 16/6/30.
//  Copyright © 2016年 Zomfice. All rights reserved.
//
#define kKEY_WINDOW [[UIApplication sharedApplication] keyWindow]
#import "GuidePageView.h"

@interface GuidePageView ()

@property (nonatomic, retain) UIScrollView * grideScroll;

@end

@implementation GuidePageView
- (id)initWithFrame:(CGRect)frame
         namesArray:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = [[UIScreen mainScreen] bounds];
        [kKEY_WINDOW addSubview:self];
        
        self.grideScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.grideScroll.contentSize = CGSizeMake(kWidth * items.count, kHeight );
        self.grideScroll.backgroundColor = [UIColor whiteColor];
        self.grideScroll.pagingEnabled = YES;
        [self addSubview:self.grideScroll];
        [self loadImagesWithArray:items];
    }
    return self;
}
- (void)loadImagesWithArray:(NSArray *)items
{
    for (int i = 0; i < items.count; i++)
    {
        //引导页图片
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kWidth, 0, kWidth, kHeight )];
        imageView.backgroundColor = [UIColor greenColor];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:items[i]];
        [self.grideScroll addSubview:imageView];
        
        //引导页文字
        UILabel * guideLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * kWidth + 20, 200, kWidth - 40, 30)];
        guideLabel.font = [UIFont systemFontOfSize:25];
        guideLabel.textAlignment = NSTextAlignmentCenter;
        guideLabel.tag = 10 + i;
        [self.grideScroll addSubview:guideLabel];
        //设置文字
        switch (guideLabel.tag - 10) {
            case 0:
            {
                guideLabel.text = @"";
                guideLabel.textColor = [UIColor purpleColor];
                guideLabel.frame = CGRectMake(100, 200, kWidth - 40, 30);
            }
                break;
            case 1:
            {
                guideLabel.text = @"";
                guideLabel.textColor = [UIColor cyanColor];
                guideLabel.frame = CGRectMake(kWidth + 30, 250, kWidth - 40, 30);
                guideLabel.textAlignment = NSTextAlignmentLeft;
            }
                break;
            case 2:
            {
                guideLabel.text = @"";
                guideLabel.textColor = [UIColor redColor];
                guideLabel.frame = CGRectMake(kWidth * 2 + 20, 250, kWidth - 40, 30);
            }
                break;
            case 3:
            {
                guideLabel.text = @"";
                guideLabel.textColor = [UIColor brownColor];
                guideLabel.frame = CGRectMake(kWidth * 3 + 20, 170, kWidth - 40, 30);
            }
                break;
                
            default:
                break;
        }
        
        if (i == items.count - 1)
        {
            self.guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _guideBtn.frame = CGRectMake((kWidth - 70) / 2,kWidth - 100,100,70);
            _guideBtn.layer.cornerRadius = 20;
            [_guideBtn setImage:[UIImage imageNamed:@"LinkedIn"] forState:UIControlStateNormal];
            [imageView addSubview:_guideBtn];
        }
    }
}


@end
