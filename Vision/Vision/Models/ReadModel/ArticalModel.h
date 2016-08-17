//
//  ArticalModel.h
//  Vision
//
//  Created by QianFeng on 16/6/13.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticalModel : NSObject
//昵称
@property (nonatomic,copy)NSString * nickname;
//头像
@property (nonatomic,copy)NSString * head_pic_url;
//又要更新了
@property (nonatomic,copy)NSString * content;
//文字段落
@property (nonatomic,copy)NSString * summary;
//传递值ID
@property (nonatomic,copy)NSString * randcode;
//分享链接
@property (nonatomic,copy)NSString * shareurl;
//图片
@property (nonatomic,copy)NSString * cover_url;
//title照片下面
@property (nonatomic,copy)NSString * title;

@property (nonatomic,copy)NSString * storyid;
@end
