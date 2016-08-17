//
//  DBManager.m
//  LoveLife
//
//  Created by 杨阳 on 15/12/29.
//  Copyright (c) 2015年 yangyang. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@implementation DBManager
{
    FMDatabase * _dataBase;
   
}
static DBManager * manager=nil;

static DBManager * manager2=nil;

+(DBManager*)defaultManager2{
    //只调用一次，保证线程安全
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if(manager2==nil){
            manager2=[[DBManager alloc]init2];
        }
    });
    
    return manager2;
}

- (instancetype)init2{
    if(self=[super init]){
        NSString * path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/selectInfor2.db"];
        
        
        //很据路径创建表
        _dataBase = [[FMDatabase alloc]initWithPath:path];
        
        //如果创建成功 打开
        if ([_dataBase open]) {
            //create table if not exists 固定写法
            //selectInfo 表的名字
            NSString * createSql = @"create table if not exists selectInfo(ID varchar(1024),title varchar(1024),coverForDetail varchar(1024),category varchar(1024),descrip varchar(1024),playUrl varchar(1024),duration varchar(1024),coverBlurred varchar(1024))";
            //createSql = @"create table if not exists selectInfo(id integer primary key autoincrement not null,class varchar(1024) data glob)";
            
            //integer 数字  varchar字符串 glob 二进制数据NSData
            if ([_dataBase executeUpdate:createSql]){//executeUpdate 返回值是BOOL
                //executeUpdate 增、删、改、创建 都是使用这个方法
                NSLog(@"创建成功");
            }else{
                NSLog(@"%@",[_dataBase lastErrorMessage]);
            }
        }
        
    }
    return self;

}


+(DBManager *)defaultManager
{
    //只调用一次，保证线程安全
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if(manager==nil){
            manager=[[DBManager alloc]init];
        
        }
    });
    
    return manager;
}

- (instancetype)init
{
    if(self=[super init]){
    
        
        NSString * path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/selectInfor.db"];
        

        //很据路径创建表
        _dataBase = [[FMDatabase alloc]initWithPath:path];
        
        //如果创建成功 打开
        if ([_dataBase open]) {
            //create table if not exists 固定写法
            //selectInfo 表的名字
            NSString * createSql = @"create table if not exists selectInfo(ID varchar(1024),title varchar(1024),coverForDetail varchar(1024),category varchar(1024),descrip varchar(1024),playUrl varchar(1024),duration varchar(1024),coverBlurred varchar(1024))";
            //createSql = @"create table if not exists selectInfo(id integer primary key autoincrement not null,class varchar(1024) data glob)";
            
            //integer 数字  varchar字符串 glob 二进制数据NSData
            if ([_dataBase executeUpdate:createSql]){//executeUpdate 返回值是BOOL
                //executeUpdate 增、删、改、创建 都是使用这个方法
                NSLog(@"创建成功");
            }else{
                NSLog(@"%@",[_dataBase lastErrorMessage]);
            }
        }

    }
    return self;
}
//插入
- (void)insertDataModel:(EveryDayModel *)model{
    
    NSString * insertSql = @"insert into selectInfo(ID,title,coverForDetail,category,descrip,playUrl,duration,coverBlurred) values(?,?,?,?,?,?,?,?)";

    BOOL success=[_dataBase executeUpdate:insertSql,model.ID,model.title,model.coverForDetail,model.category,model.descrip,model.playUrl,model.duration,model.coverBlurred];
  
    if (!success) {
        NSLog(@"%@",[_dataBase lastErrorMessage]);
    }else{
        NSLog(@"插入成功");
    }

}
//查找
- (BOOL)isHasDataIDFromTable:(NSString *)dataId
{
    
    NSString * isSql = @"select *from selectInfo where id=?";

    //FMResultSet 查询结果的集合类
    FMResultSet * set = [_dataBase executeQuery:isSql,dataId];
    //[set next] 查找当前行 找到继续中查找下一行
    if ([set next]) {
        return YES;
    }else{
        return NO;
    }
    return [set next];//next 返回时一个BOOL
}
//删除
- (void)deleteNameFromTable:(NSString *)dataId
{
    
    NSString * deleteSql = @"delete from selectInfo where id=?";
    if ([_dataBase executeUpdate:deleteSql,dataId]) {
        NSLog(@"删除成功");
    }
    
}
- (NSArray *)getData{
    
    NSString *resultSql = @"select *from selectInfo";
    
    FMResultSet * set = [_dataBase executeQuery:resultSql];
    NSMutableArray * arr = [NSMutableArray array];
  
    
    while ([set next]) {
      EveryDayModel* model = [[EveryDayModel alloc]init];
        model.ID = [set stringForColumn:@"ID"];
        model.title = [set stringForColumn:@"title"];
        model.coverForDetail=[set stringForColumn:@"coverForDetail"];
        model.category=[set stringForColumn:@"category"];
        model.descrip=[set stringForColumn:@"descrip"];
        model.playUrl = [set stringForColumn:@"playUrl"];
        model.duration = [set stringForColumn:@"duration"];
        model.coverBlurred = [set stringForColumn:@"coverBlurred"];
        [arr addObject:model];
    }
    return arr;
}
//[self.head_pic_url sd_setImageWithURL:[NSURL URLWithString:model.head_pic_url]];
//self.nickname.text = model.nickname;
//self.summary.text = model.content;
//self.content.text = model.summary;
//[self.cover_url sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
//self.title.text = model.title;

@end
