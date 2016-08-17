//
//  CategoryModel.m
//  Vision
//
//  Created by QianFeng on 16/6/29.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.idd = value;
    }
}

@end
