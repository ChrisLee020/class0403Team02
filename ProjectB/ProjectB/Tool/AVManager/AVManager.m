//
//  AVManager.m
//  PianKe
//
//  Created by Chris on 16/7/26.
//  Copyright © 2016年 kimlee. All rights reserved.
//

#import "AVManager.h"
#import "WeakTimerTargetObject.h"

@interface AVManager ()

//判读是否正在播放
//@property (nonatomic, assign)BOOL isPlaying;



@property (nonatomic, strong)NSTimer *timer;



@end

@implementation AVManager

//创建一个播放音乐的单例
+ (AVManager *)shareInstance
{
    
    static AVManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    
    dispatch_once(&onceToken, ^{
       
        manager = [[AVManager alloc] init];
        
        manager.avplay = [[AVPlayer alloc]init];
        
    });
    
    
    
    return manager;
}

//懒加载音乐列表
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
    
    [self.avplay replaceCurrentItemWithPlayerItem:item];
    
//    [self.avplay play];
    
    if (!_timer)
    {
        _timer = [WeakTimerTargetObject scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(autoNextMusic) userInfo:nil repeats:YES];
    }
    
    

}

//自动下一首
- (void)autoNextMusic
{
    float playDuration = self.playDuration;
    
    NSInteger playDurationA = playDuration / 60;
    
    NSInteger playDurationB = (int)playDuration % 60;
    
    float playCuruentTime = self.curuentTime;
    
    NSInteger playCuruentTimeA = playCuruentTime / 60;
    
    NSInteger playCuruentTimeB = (int)playCuruentTime % 60;
    
    if (playDuration &&playDurationA == playCuruentTimeA && playDurationB == playCuruentTimeB)
    {
        
        [self next];
        
        self.changeMusic = YES;
    }
   
 
}


//上一首
- (NSInteger)above
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
    
    self.isPlaying = YES;
    
    return self.playIndex;
}

//下一首
- (NSInteger)next
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
    
    self.isPlaying = YES;
    
    return self.playIndex;
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
    
    self.isPlaying = YES;
}

- (void)stopPlay
{
    [self.avplay pause];
    
    self.isPlaying = NO;
}

//改变音乐播放进度
- (void)playProgress:(float)progress
{
    CMTime time = self.avplay.currentItem.currentTime;
    
    time.value = self.avplay.currentTime.timescale * progress;
    
//    跳到某个时间点执行
    [self.avplay seekToTime:time];
    
    [self.avplay play];
    
    self.isPlaying = YES;
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
