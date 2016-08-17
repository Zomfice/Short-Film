//
//  FilmModel.h
//  Vision
//
//  Created by QianFeng on 16/7/4.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilmModel : NSObject
//图片
@property (nonatomic,copy) NSString *adTrack;
//播放时间
@property (nonatomic,copy) NSNumber *duration;
//表述
@property (nonatomic,copy) NSString *descriptionL;
//播放链接
@property (nonatomic,copy) NSString *playUrl;
//标题
@property (nonatomic,copy) NSString *title;
//分类
@property (nonatomic,copy) NSString *video_cate;

@property (nonatomic,copy) NSNumber *collectionCount;

@property (nonatomic,copy) NSNumber * playCount;
@end
