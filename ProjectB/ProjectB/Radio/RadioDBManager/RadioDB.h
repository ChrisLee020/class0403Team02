//
//  RadioDB.h
//  ProjectB
//
//  Created by Chris on 16/8/8.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "UnitModel.h"

@interface RadioDB : NSObject

+ (RadioDB *)shareDataHandler;

//创建表
- (BOOL)createTable:(NSString *)tableName;

//删除表
- (BOOL)deleteTable:(NSString *)tableName;

//添加数据
- (BOOL)addModel:(UnitModel *)model formTable:(NSString *)tableName;

//查找数据
- (NSMutableArray *)selectFormTable:(NSString *)tableName;

@end
