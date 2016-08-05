//
//  AVManager.h
//  PianKe
//
//  Created by Chris on 16/7/26.
//  Copyright © 2016年 kimlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVManager : NSObject

@property (nonatomic, strong) AVPlayer *avplay;

@property (nonatomic, strong)NSMutableArray *musicUrls;

@property (nonatomic, assign)BOOL isPlaying;

//创建一个播放音乐的单例
+ (AVManager *)shareInstance;

//添加音乐的播放列表(文件)
- (void)setPlayList:(NSMutableArray *)playList flag:(NSInteger)number;

//上一首
- (void)above;

//下一首
- (void)next;

//播放或暂停
- (void)play;

//改变音乐播放进度
- (void)playProgress:(float)progress;

//音频文件的总时长
- (float)playDuration;

//音频文件的当前时长
- (float)curuentTime;


- (void)startPlay;

- (void)stopPlay;

@end
