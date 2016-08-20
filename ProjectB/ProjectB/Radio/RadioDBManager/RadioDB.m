//
//  RadioDB.m
//  ProjectB
//
//  Created by Chris on 16/8/8.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "RadioDB.h"



@interface RadioDB ()

@property (nonatomic, strong)FMDatabase *db;

@end

@implementation RadioDB

+ (RadioDB *)shareDataHandler
{
    static RadioDB *radioDB = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        radioDB = [[RadioDB alloc] init];
        
    });
    
    return radioDB;
}

- (instancetype)init
{
    if (self = [super init])
    {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        NSString *path = [docPath stringByAppendingPathComponent:@"Radio.sqlite"];
        
        self.db = [FMDatabase databaseWithPath:path];
    }
    return self;
}

//创建表
- (BOOL)createTable:(NSString *)tableName
{
    
    if ([self.db open])
    {
        NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists %@(radio_id integer primary key,name text,cover text,seasonID text,avatar text,email text,nickname text, program_count text)",tableName];
        BOOL result = [self.db executeUpdate:sqlStr];
        
        [self.db close];
        
        return result;
    }
    
    return NO;
}


//删除表
- (BOOL)deleteTable:(NSString *)tableName
{
    
    if ([self.db open])
    {
        NSString *sqlStr = [NSString stringWithFormat:@"delete from %@", tableName];
        
        BOOL result = [self.db executeUpdate:sqlStr];
        
        [self.db close];
        
        return result;
    }
    
    return NO;
}

//添加数据
- (BOOL)addModel:(UnitModel *)model formTable:(NSString *)tableName {
    
    if([self.db open])
    {
        if ([tableName isEqualToString:@"season"])
        {
            
            BOOL result = [self.db executeUpdateWithFormat:@"insert into season (name,cover) values (%@,%@);", model.name, model.cover];
            
            [self.db close];
            
            return result;
        }
        else if([tableName isEqualToString:@"anchor"])
        {
            
            BOOL result = [self.db executeUpdateWithFormat:@"insert into anchor (avatar,nickname,email,seasonID,program_count) values (%@,%@,%@,%@,%@);", model.avatar, model.nickname, model.email, model.seasonID, model.program_count.stringValue];
            
            [self.db close];
            
            return result;
            
        }
        
    }
    
    
    
    return NO;
}

//查找数据
- (NSMutableArray *)selectFormTable:(NSString *)tableName
{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    if([self.db open])
    {
        NSString *sqlStr = [NSString stringWithFormat:@"select * from %@", tableName];
        
        FMResultSet *resultSet = [self.db executeQuery:sqlStr];
        
        if ([tableName isEqualToString:@"season"])
        {
            while ([resultSet next])
            {
                UnitModel *model = [[UnitModel alloc] init];
                
                model.name = [resultSet stringForColumn:@"name"];
                
                model.cover = [resultSet stringForColumn:@"cover"];
                
                [dataArray addObject:model];
            }
            
            [self.db close];
            
            return [dataArray copy];
        }
        else if([tableName isEqualToString:@"anchor"])
        {
            
            while ([resultSet next])
            {
                UnitModel *model = [[UnitModel alloc] init];
                
                model.avatar = [resultSet stringForColumn:@"avatar"];
                
                model.email = [resultSet stringForColumn:@"email"];
                
                model.nickname = [resultSet stringForColumn:@"nickname"];
                
                model.seasonID = [resultSet stringForColumn:@"seasonID"];
                
                NSString *countStr = [resultSet stringForColumn:@"program_count"];
                
                NSInteger prCount = countStr.integerValue;
                
                NSNumber *program_count = [NSNumber numberWithInteger:prCount];
                
                model.program_count = program_count;
                
                [dataArray addObject:model];
                
            }
            
            [self.db close];
            
            return [dataArray copy];
            
        }
        
        
        
        
    }
    
    return nil;
    
}
@end
