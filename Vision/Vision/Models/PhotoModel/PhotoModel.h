//
//  PhotoModel.h
//  Vision
//
//  Created by QianFeng on 16/6/15.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject
//图片标题
@property (nonatomic,copy) NSString *title;
//分类ID
@property (nonatomic,copy) NSString *category;
//大图
@property (nonatomic,copy) NSString *thumb_url;
//小图
@property (nonatomic,copy) NSString *image_url;
@end
