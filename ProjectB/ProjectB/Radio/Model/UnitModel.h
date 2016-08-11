//
//  UnitModel.h
//  ProjectB
//
//  Created by Chris on 16/7/30.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitModel : NSObject

@property (nonatomic, copy) NSString *cover;    //封面

@property (nonatomic, copy) NSString *name;     //标题

@property (nonatomic, copy) NSNumber *program_count;   //节目数量

@property (nonatomic, copy) NSString *title;    //多乐频道标题

@property (nonatomic, strong) NSDictionary *poster_path;    //多乐图片封面

@property (nonatomic, copy) NSString *duoleID;      //多乐频道ID

@end
