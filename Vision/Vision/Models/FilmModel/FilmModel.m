//
//  FilmModel.m
//  Vision
//
//  Created by QianFeng on 16/7/4.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "FilmModel.h"

@implementation FilmModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        self.descriptionL = value;
    }
}

@end
