//
//  PlayViewController.m
//  ProjectB
//
//  Created by Chris on 16/8/1.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayViewController.h"
#import "AVManager.h"
#import "ListDetailModel.h"
#import "Masonry.h"
#import "WeakTimerTargetObject.h"
#import "AnimationDismissProxy.h"

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

@property (strong, nonatomic) IBOutlet UISlider *silder;


@end


@implementation PlayViewController

- (void)awakeFromNib
{
    
}

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
    
    [self settingTop];
}

- (void)settingTop
{
    
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [topBtn setImage:[UIImage imageNamed:@"reback.png"] forState:UIControlStateNormal];
    
    topBtn.frame = CGRectMake(0, 0, 40, 40);
    
    [topBtn addTarget:self action:@selector(reBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:topBtn];
    
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(10);
        
        make.top.equalTo(self.view.mas_top).offset(25);
        
    }];
    
}

#pragma mark   界面设置
- (void)createLayout
{
    self.view.layer.anchorPoint = CGPointMake(0.5, 2.0);
    
    self.view.frame = kScreenMainBounds;
    
    //    创建拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizePanGestrue:)];
    
    //    把手势添加到view中
    [self.view addGestureRecognizer:pan];

//    CD的左右偏移量, 加上歌手图片缩小的值
    CGFloat radiuSize = (kScreenWidth - 210) / 2;
    
    self.singerImageView.layer.cornerRadius = radiuSize;
    
    self.singerImageView.layer.masksToBounds = YES;
    
    self.backGroundImage.userInteractionEnabled = YES;
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    
    effectView.alpha = 0.8;
    
    effectView.frame = [UIScreen mainScreen].bounds;
    
    [self.silder setThumbImage:[UIImage imageNamed:@"dot.png"] forState:UIControlStateNormal];
    
    [self.backGroundImage addSubview:effectView];
    
    self.av = [AVManager shareInstance];
 
    [self.av setPlayList:self.musicList flag:self.number];
        
    [self playBtn:self];
    
    [self loadData:self.number];
    
}



#pragma mark   数据加载
- (void)loadData:(NSInteger)numb
{
    if (self.type)
    {
        
        self.titleLabel.text = self.detailList[numb];
        
        self.author.text = self.type.author;
        
//        self.titleLabel.text = [NSString stringWithFormat:@"%ld",self.number];
        
        NSDictionary *dict = self.type.poster_path;
        
        [self.singerImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"poster_180_260"]]];
        [self.backGroundImage sd_setImageWithURL:[NSURL URLWithString:dict[@"poster_source"]]];
        
    }
    else
    {
        ListDetailModel *listModel = self.detailList[numb];
        
        self.titleLabel.text = listModel.title;
        
        self.author.text = listModel.author;

        [self.singerImageView sd_setImageWithURL:[NSURL URLWithString:listModel.cover]];


        [self.backGroundImage sd_setImageWithURL:[NSURL URLWithString:listModel.background]];
        
    }
    
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

    self.number = [self.av above];
    
    [self loadData:self.number];
    
}

//下一首
- (IBAction)nextMusic:(id)sender {
    
    self.number = [self.av next];
    
    [self loadData:self.number];
    
}

//改变播放位置
- (IBAction)changePlayLocation:(id)sender {
    
    [self.av playProgress:self.silder.value];
    
}

#pragma mark    按钮方法
- (void)reBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self removeTimer];
}

#pragma mark    拖拽手势方法
- (void)didRecognizePanGestrue:(UIPanGestureRecognizer *)recognizer
{
//    UIViewController *vc = self.presentedViewController;
//    vc.view.alpha = 1;
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    [appDelegate.window addSubview:vc.view];


    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        
                if (ABS(recognizer.view.transform.b) > 0.16)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        else
        {
            recognizer.view.transform = CGAffineTransformIdentity;
            
        }
    }
    else
    {
        CGFloat offsetX = [recognizer translationInView:recognizer.view].x;
        
        CGFloat percent = offsetX / self.view.bounds.size.width;
        
        CGFloat radians = M_PI_4 * percent;
        
        recognizer.view.transform = CGAffineTransformMakeRotation(radians);
        
        [self.tabBarController.tabBar setHidden:YES];
    }
    
//    [appdelegate.window willRemoveSubview:vc.view];
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
    
    self.timeL.text = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld",(long)playCuruentTimeA ,(long)playCuruentTimeB, (long)playDurationA, (long)playDurationB];
    
//    改变进度条的进度
    self.silder.maximumValue = self.av.playDuration;
    
    self.silder.value = self.av.curuentTime;

////    判断播放进度完结时播放下一首
    if (self.av.changeMusic)
    {
       self.number = self.av.playIndex;
        
        [self loadData: self.number];
        
        self.av.changeMusic = NO;
    }

}

//添加定时器
- (void)addTimer
{
    if (self.timer)
    {
        return;
    }
    
    self.timer = [WeakTimerTargetObject scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
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
