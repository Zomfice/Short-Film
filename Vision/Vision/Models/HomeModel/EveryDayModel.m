//
//  EveryDayModel.m
//  Vision
//
//  Created by qianfeng0 on 16/6/11.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "EveryDayModel.h"

@implementation EveryDayModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"description"]) {
        
        self.descrip = value;
        
    }
    
    if ([key isEqualToString:@"id"]) {
        
        self.ID = [value stringValue];
        
    }
    
}
- (void)setValue:(id)value forKey:(NSString *)key{
    
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"duration"]) {
        
        self.duration = [value stringValue];
        
    }
}
@end
