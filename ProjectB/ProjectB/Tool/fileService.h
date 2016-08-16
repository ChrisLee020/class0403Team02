//
//  fileService.h
//  ProjectB
//
//  Created by lanou on 16/8/16.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fileService : NSObject


//计算单个文件大小
+(float)fileSizeAtPath:(NSString *)path;
//计算目录大小
+(float)folderSizeAtPath:(NSString *)path;
//清理缓存文件
+(void)clearCache:(NSString *)path;

@end
