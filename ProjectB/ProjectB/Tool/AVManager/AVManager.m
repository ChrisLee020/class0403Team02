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


{
    BOOL isRemoveNot; //是否移除通知
}

//判读是否正在播放
//@property (nonatomic, assign)BOOL isPlaying;



@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, strong)NSString *url;



//@property (nonatomic, assign)id playTimeObserver;

//@property (nonatomic, assign)BOOL isRemoveNot;  //是否移除


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
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
        
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
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
    if (isRemoveNot)
    {
        [self.playItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        
        isRemoveNot = NO;
    }
    
    
    if (![playList[number] isEqualToString:self.url])
    {
        
        
        //    记录播放列表
        self.musicUrls = [playList copy];
        
        //    记录当前播放音乐的下标
        self.playIndex = number;
        
        self.url = playList[number];
        
        //    创建播放器
        NSString *urlStr = playList[number];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        
        self.playItem = [[AVPlayerItem alloc]initWithURL:url];
        
        [self.avplay replaceCurrentItemWithPlayerItem:self.playItem];
        
        [self.playItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        
        isRemoveNot = YES;
        
        if (!_timer)
        {
            _timer = [WeakTimerTargetObject scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(autoNextMusic) userInfo:nil repeats:YES];
        }
        
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
    if (isRemoveNot)
    {
        [self.playItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        
        isRemoveNot = NO;
    }
    
    self.playIndex -- ;
    
    if (self.playIndex == -1)
    {
        self.playIndex = self.musicUrls.count -1;
    }
    
    NSURL *url = [NSURL URLWithString:self.musicUrls[self.playIndex]];
    
    self.url = self.musicUrls[self.playIndex];
    
    self.playItem = [[AVPlayerItem alloc] initWithURL:url];
    
    [self.avplay replaceCurrentItemWithPlayerItem:self.playItem];
    
    [self.playItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    
    isRemoveNot = YES;
    
    if (self.isPlaying)
    {
        [self.avplay play];
    }
    
    
    self.changeMusic = YES;
    
    return self.playIndex;
    
}

//下一首
- (NSInteger)next
{
    if (isRemoveNot)
    {
        [self.playItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        
        isRemoveNot = NO;
    }
    
    self.playIndex ++ ;
    
    if (self.playIndex == self.musicUrls.count)
    {
        self.playIndex = 0;
        
    }
    
    NSURL *url = [NSURL URLWithString:self.musicUrls[self.playIndex]];
    
    self.url = self.musicUrls[self.playIndex];
    
    self.playItem = [[AVPlayerItem alloc] initWithURL:url];
    
    [self.avplay replaceCurrentItemWithPlayerItem:self.playItem];
    
    [self.playItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    
    isRemoveNot = YES;
    
    if(self.isPlaying)
    {
        [self.avplay play];
    }
    
    self.changeMusic = YES;
    
    return self.playIndex;
}

//播放或暂停
- (void)play
{
    
    if (self.isPlaying)
    {
        [self.avplay pause];
        
        self.isPlaying = NO;
    }
    else
    {
        [self.avplay play];
        
        self.isPlaying = YES;
    }
    
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

//计算缓冲进度
- (NSTimeInterval)availableDuration
{
    NSArray *loadedTimeRanges = [[self.avplay currentItem] loadedTimeRanges];
    
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue]; //获取缓冲区
    
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    
    NSTimeInterval result = startSeconds + durationSeconds; // 计算缓冲进度
    
    return result;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (!self.playItem.playbackBufferEmpty) {
        
        [self.avplay play];
        
    }
}


@end
