//
//  AVManager.m
//  PianKe
//
//  Created by Chris on 16/7/26.
//  Copyright © 2016年 kimlee. All rights reserved.
//

#import "AVManager.h"

@interface AVManager ()

//判读是否正在播放
@property (nonatomic, assign)BOOL isPlaying;

//当前正在播放的音乐下标
@property (nonatomic, assign)NSInteger playIndex;


@end

@implementation AVManager

//创建一个播放音乐的单例
+ (AVManager *)shareInstance
{
    
    static AVManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    
    dispatch_once(&onceToken, ^{
       
        manager = [[AVManager alloc] init];
    });
    
    return manager;
}


- (NSMutableArray *)musicUrls
{
    if (!_musicUrls)
    {
        _musicUrls = [[NSMutableArray alloc] init];
    }
    
    return _musicUrls;
}

//添加音乐的播放列表(文件)
- (void)setPlayList:(NSMutableArray *)playList flag:(NSInteger)number
{
  
//    记录播放列表
    self.musicUrls = [playList copy];
    
//    记录当前播放音乐的下标
    self.playIndex = number;
    
//    创建播放器
    NSString *urlStr = playList[number];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
    
    self.avplay = [[AVPlayer alloc] initWithPlayerItem:item];
    
//    [self.avplay play];
}

//上一首
- (void)above
{
    self.playIndex -- ;
    
    if (self.playIndex == -1)
    {
        self.playIndex = self.musicUrls.count -1;
    }
    
    NSURL *url = [NSURL URLWithString:self.musicUrls[self.playIndex]];
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    
    [self.avplay replaceCurrentItemWithPlayerItem:item];
    
    [self.avplay play];
}

//下一首
- (void)next
{
    self.playIndex ++ ;
    
    if (self.playIndex == self.musicUrls.count)
    {
        self.playIndex = 0;
        
    }
    
    NSURL *url = [NSURL URLWithString:self.musicUrls[self.playIndex]];
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    
    [self.avplay replaceCurrentItemWithPlayerItem:item];
    
    [self.avplay play];
}

//播放或暂停
- (void)play
{
    if (self.isPlaying)
    {
        [self.avplay pause];
    }
    else
    {
        [self.avplay play];
    }
    
     self.isPlaying = !self.isPlaying;
}

- (void)startPlay
{
    [self.avplay play];
}

- (void)stopPlay
{
    [self.avplay pause];
}

//改变音乐播放进度
- (void)playProgress:(float)progress
{
    CMTime time = self.avplay.currentItem.currentTime;
    
    time.value = self.avplay.currentTime.timescale * progress;
    
//    跳到某个时间点执行
    [self.avplay seekToTime:time];
    
    [self.avplay play];
}

//音频文件的总时长
- (float)playDuration
{
    if (self.avplay.currentItem.duration.timescale == 0)
    {
        return 0;
    }
    
    float second = self.avplay.currentItem.duration.value / self.avplay.currentItem.duration.timescale;
    
    return second;
}

//当前已经播放时长
- (float)curuentTime
{
    if (self.avplay.currentItem.duration.timescale == 0)
    {
        return 0;
    }
    
   return self.avplay.currentItem.currentTime.value / self.avplay.currentItem.currentTime.timescale;
}


@end
