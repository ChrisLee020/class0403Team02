//
//  ListDetailModel.h
//  ProjectB
//
//  Created by Chris on 16/7/30.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListDetailModel : NSObject

@property (nonatomic, copy) NSString *background;   //播放背景页

@property (nonatomic, copy) NSString *cover;    //头像

@property (nonatomic, copy) NSString *title;    //标题

@property (nonatomic, copy) NSString *author;    //主播

@property (nonatomic, strong)NSDictionary *audio;

@property (nonatomic, copy) NSNumber *total_play;   //播放次数

@property (nonatomic, copy) NSString *album_id;

@end
