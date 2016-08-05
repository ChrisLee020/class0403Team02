//
//  detailBookModel2.h
//  ProjectB
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detailBookModel2 : NSObject
@property(nonatomic,strong)NSString *bookID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *zone;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *last_update_volume_name;
@property(nonatomic,strong)NSString *last_update_chapter_name;
@property(nonatomic,strong)NSString *last_update_volume_id;
@property(nonatomic,strong)NSString *last_update_chapter_id;
@property(nonatomic,strong)NSString *last_update_time;
@property(nonatomic,strong)NSString *cover;
@property(nonatomic,strong)NSNumber *hot_hits;
@property(nonatomic,strong)NSString *introduction;
@property(nonatomic,strong)NSArray *types;
@property(nonatomic,strong)NSString *authors;
@property(nonatomic,strong)NSNumber *subscribe_num;
@property(nonatomic,strong)NSArray *volume;

@end
