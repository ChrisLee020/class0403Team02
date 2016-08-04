//
//  SeriesModel.h
//  ProjectB
//
//  Created by Chris on 16/8/4.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeriesModel : NSObject

@property (nonatomic, copy) NSString *author;   //主播

@property (nonatomic, copy) NSString *intro;    //简介

@property (nonatomic, strong) NSDictionary *poster_path;    //封面

@property (nonatomic, copy) NSString *title;    //标题

@property (nonatomic, copy) NSString *uploader; //上传者

@property (nonatomic, copy) NSString *play; //播放数

@property (nonatomic, copy) NSString *source_url;   //音频

@property (nonatomic, copy) NSString *praise;   //点赞

@end
