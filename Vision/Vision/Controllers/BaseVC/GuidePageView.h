//
//  GuidePageView.h
//  Vision
//
//  Created by QianFeng on 16/6/30.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuidePageView : UIView

@property (nonatomic,strong)UIButton * guideBtn;

- (id)initWithFrame:(CGRect)frame namesArray:(NSArray *)items;

@end
