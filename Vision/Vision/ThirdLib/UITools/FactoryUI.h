//
//  FactoryUI.h
//  Vision
//
//  Created by QianFeng on 16/6/14.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FactoryUI : NSObject

//UIView
+ (UIView *)createViewWithFrame:(CGRect)frame;
//UILabel
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;
//UIButton
+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor type:(UIButtonType)type target:(id)target  selector:(SEL)selector;
//UIImageView
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;
//UITextField
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame text:(NSString *)text placeholder:(NSString *)placeholder;

@end
