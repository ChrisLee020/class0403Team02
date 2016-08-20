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

@property (nonatomic, copy) NSString *seasonID;      //四季主播ID

@property (nonatomic, copy) NSString *email;    //主播邮箱

@property (nonatomic, copy) NSString *avatar;   //主播头像

@property (nonatomic, copy) NSString *nickname; //频道名称

@end
