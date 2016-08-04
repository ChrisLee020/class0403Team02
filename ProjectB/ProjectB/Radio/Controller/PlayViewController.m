//
//  PlayViewController.m
//  ProjectB
//
//  Created by Chris on 16/8/1.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "PlayViewController.h"
#import "AVManager.h"
#import "ListDetailModel.h"
#import "Masonry.h"
#import "WeakTimerTargetObject.h"

@interface PlayViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *backGroundImage;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *author;

@property (strong, nonatomic) IBOutlet UIImageView *singerImageView;

@property (strong, nonatomic) IBOutlet UILabel *timeL;

@property (strong, nonatomic) IBOutlet UIButton *playButton;

@property (strong, nonatomic) IBOutlet UIImageView *cdImage;

@property (nonatomic, strong)CADisplayLink *singerTimer;

@property (nonatomic, assign, getter=isPlaying)BOOL playing;

@property (nonatomic, strong)AVManager *av;

@property (nonatomic, weak)NSTimer *timer;


@end

@implementation PlayViewController

#pragma mark    懒加载
- (CADisplayLink *)singerTimer
{
    if (_singerTimer == nil)
    {
        _singerTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(setImageRoutation)];
        
        [_singerTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    return _singerTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createLayout];
    
    
}


#pragma mark   界面设置
- (void)createLayout
{
    
//    CD的左右偏移量, 加上歌手图片缩小的值
    CGFloat radiuSize = (kScreenWidth - 210) / 2;
    
    self.singerImageView.layer.cornerRadius = radiuSize;
    
    self.singerImageView.layer.masksToBounds = YES;
    
    self.backGroundImage.userInteractionEnabled = YES;
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    
    effectView.alpha = 0.8;
    
    effectView.frame = [UIScreen mainScreen].bounds;
    
    [self.backGroundImage addSubview:effectView];
    
    self.av = [AVManager shareInstance];
    
    [self.av setPlayList:self.musicList flag:self.number];
    
    [self playBtn:self];
    
    [self loadData];
    

    
}



#pragma mark   数据加载
- (void)loadData
{
    ListDetailModel *listModel = self.detailList[self.number];
    
    self.titleLabel.text = listModel.title;
    
    self.author.text = listModel.author;
    
    [self.singerImageView sd_setImageWithURL:[NSURL URLWithString:listModel.cover]];
    
    [self.backGroundImage sd_setImageWithURL:[NSURL URLWithString:listModel.background]];
    
  
    
}

//歌手图片转动动画
- (void)setImageRoutation
{
    self.singerImageView.transform = CGAffineTransformRotate(self.singerImageView.transform, M_PI * 2 / 60 / 30);
}

#pragma mark   按钮实行方法
//播放/暂停
- (IBAction)playBtn:(id)sender {
  
    
    self.playing = !self.isPlaying;
    
    if (self.playing)
    {
        [self.playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
        self.singerTimer.paused = NO;
        
        [self.av startPlay];
        
        [self removeTimer];
        
        [self addTimer];
    }
    else
    {
        [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        
        self.singerTimer.paused = YES;
        
        [self.av stopPlay];
        
        [self removeTimer];
    }
    
}

//上一首
- (IBAction)aboveMusic:(id)sender {
    
    self.number --;
    
    if (self.number == -1)
    {
        self.number = self.musicList.count - 1;
    }
    

    [self loadData];
    
    [self.av above];
    
}

//下一首
- (IBAction)nextMusic:(id)sender {
    
    self.number ++;
    
    if (self.number == self.musicList.count)
    {
        self.number = 0;
    }
    
    [self loadData];
    
    [self.av next];
    
}

#pragma mark   定时器方法
- (void)changeTime
{
    float playDuration = self.av.playDuration;
    
    NSInteger playDurationA = playDuration / 60;
    
    NSInteger playDurationB = (int)playDuration % 60;
    
    float playCuruentTime = self.av.curuentTime;
    
    NSInteger playCuruentTimeA = playCuruentTime / 60;
    
    NSInteger playCuruentTimeB = (int)playCuruentTime % 60;
    
    self.timeL.text = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld",playCuruentTimeA ,playCuruentTimeB, playDurationA, playDurationB];
    
//    判断播放进度完结时播放下一首
    if (playDuration && playDurationA == playCuruentTimeA && playDurationB == playCuruentTimeB)
    {
        [self nextMusic:self];
    }
    
}

//添加定时器
- (void)addTimer
{
    if (self.timer)
    {
        return;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
}

//移除计时器
- (void)removeTimer
{
    [self.timer invalidate];
    
    self.timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
