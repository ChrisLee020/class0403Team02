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
        NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists %@(radio_id integer primary key,name text,cover text,poster_pathValue1 text,poster_pathValue2 text,poster_pathValue3 text,duoleID text,title text)",tableName];
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
        else if([tableName isEqualToString:@"traditional"])
        {
          
            
            BOOL result = [self.db executeUpdateWithFormat:@"insert into traditional(title,poster_pathValue1,poster_pathValue2,poster_pathValue3,duoleID) values(%@,%@,%@,%@,%@)" , model.title, model.poster_path[@"poster_180_260"], model.poster_path[@"poster_400_400"], model.poster_path[@"poster_source"], model.duoleID];
            
            [self.db close];
            
            return result;
        }
        else if([tableName isEqualToString:@"joke"])
        {
           BOOL result = [self.db executeUpdateWithFormat:@"insert into joke(title,poster_pathValue1,poster_pathValue2,poster_pathValue3,duoleID) values(%@,%@,%@,%@,%@)" , model.title, model.poster_path[@"poster_180_260"], model.poster_path[@"poster_400_400"], model.poster_path[@"poster_source"], model.duoleID];
            
            
            [self.db close];
            
            return result;
        }
        else if([tableName isEqualToString:@"queen"])
        {
            
            BOOL result = [self.db executeUpdateWithFormat:@"insert into queen(title,poster_pathValue1,poster_pathValue2,poster_pathValue3,duoleID) values(%@,%@,%@,%@,%@)" , model.title, model.poster_path[@"poster_180_260"], model.poster_path[@"poster_400_400"], model.poster_path[@"poster_source"], model.duoleID];
            
            
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
        else if([tableName isEqualToString:@"traditional"])
        {
            while ([resultSet next])
            {
                UnitModel *model = [[UnitModel alloc] init];
                
                model.title = [resultSet stringForColumn:@"title"];
                
                model.duoleID = [resultSet stringForColumn:@"duoleID"];
                
                NSString *value1 = [resultSet stringForColumn:@"poster_pathValue1"];
                
                NSString *value2 = [resultSet stringForColumn:@"poster_pathValue2"];
                
                NSString *value3 = [resultSet stringForColumn:@"poster_pathValue3"];
                
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys: value1, @"poster_180_260", value2, @"poster_400_400", value3, @"poster_source", nil];
                
                model.poster_path = dict;
                
                
                [dataArray addObject:model];
                
            }
            
             [self.db close];
            
            return [dataArray copy];
        }
        else if([tableName isEqualToString:@"joke"])
        {
            while ([resultSet next])
            {
                UnitModel *model = [[UnitModel alloc] init];
                
                model.title = [resultSet stringForColumn:@"title"];
                
                model.duoleID = [resultSet stringForColumn:@"duoleID"];
                
                NSString *value1 = [resultSet stringForColumn:@"poster_pathValue1"];
                
                NSString *value2 = [resultSet stringForColumn:@"poster_pathValue2"];
                
                NSString *value3 = [resultSet stringForColumn:@"poster_pathValue3"];
                
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys: value1, @"poster_180_260", value2, @"poster_400_400", value3, @"poster_source", nil];
                
                model.poster_path = dict;
                
                
                [dataArray addObject:model];
                
            }
            
            [self.db close];
            
            return [dataArray copy];
        }
        else if([tableName isEqualToString:@"queen"])
        {
            while ([resultSet next])
            {
                UnitModel *model = [[UnitModel alloc] init];
                
                model.title = [resultSet stringForColumn:@"title"];
                
                model.duoleID = [resultSet stringForColumn:@"duoleID"];
                
                NSString *value1 = [resultSet stringForColumn:@"poster_pathValue1"];
                
                NSString *value2 = [resultSet stringForColumn:@"poster_pathValue2"];
                
                NSString *value3 = [resultSet stringForColumn:@"poster_pathValue3"];
                
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys: value1, @"poster_180_260", value2, @"poster_400_400", value3, @"poster_source", nil];
                
                model.poster_path = dict;
                
                
                [dataArray addObject:model];
                
            }
            
            [self.db close];
            
            return [dataArray copy];
        }


       
    }
    
    return nil;
    
}
@end
