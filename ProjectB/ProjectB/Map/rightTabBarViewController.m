//
//  rightTabBarViewController.m
//  ProjectB
//
//  Created by lanou on 16/7/29.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

typedef void (^StepNumberBlock)(NSMutableDictionary *,NSInteger);

#import "AppDelegate.h"
#import "rightTabBarViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "ZJLabel.h"
#import "MapViewController.h"
#import "HistoryViewController.h"

@interface rightTabBarViewController ()<UIApplicationDelegate>

@property(nonatomic,strong)CMMotionManager *motionManager;


@property(nonatomic,assign)NSInteger stepNumber;
@property(nonatomic,strong)NSMutableDictionary *stepNumberDict;
@property(nonatomic,strong)NSString *todaydate;
@property(nonatomic,assign)BOOL iswalking;
@property(nonatomic,assign)NSInteger targetStepNumber;
@property(nonatomic,strong)ZJLabel *zjlabel;
@property(nonatomic,strong)UIButton *btn5k;
@property(nonatomic,strong)UIButton *btn10k;
@property(nonatomic,strong)UIButton *btn15k;
@property(nonatomic,strong)AppDelegate *delegate;
//@property(nonatomic,copy)StepNumberBlock *stepnumberblock;

@end

@implementation rightTabBarViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.stepNumber++;
    
    _zjlabel.present = _stepNumber * 1.0 / _targetStepNumber;
    _zjlabel.NowStep = _stepNumber;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:self.view.frame];
    backImage.image = [UIImage imageNamed:@"SportBack.jpg"];
    backImage.alpha = 0.45;
    [self.view addSubview:backImage];
    self.title = @"健康";
    _iswalking = NO;
    static NSInteger a = 0;
    _stepNumber = a;
    [self gravityrespondsetting];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(PushMap)];
    
    _targetStepNumber = 5000;
    
    [self setButtons];
    [self.navigationController setNavigationBarHidden:YES];
    
    _delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _delegate.stepNumberDictionary = self.stepNumberDict;
    _delegate.todaydate = _todaydate;
    _delegate.stepNumber = &(_stepNumber);
    
    
    
    
    
    
    
    
    _zjlabel = [[ZJLabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.8,[UIScreen mainScreen].bounds.size.width  * 0.8)];
    _zjlabel.center = self.view.center;
    _zjlabel.present = _stepNumber / _targetStepNumber * 1.0;
    [self.view addSubview:_zjlabel];
    _zjlabel.layer.cornerRadius = [UIScreen mainScreen].bounds.size.width * 0.4;
    _zjlabel.layer.masksToBounds = YES;
    _zjlabel.backgroundColor = [UIColor clearColor];
    
    //给图层添加一个有色边框
    _zjlabel.layer.borderWidth = 2;
    _zjlabel.layer.borderColor = [[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:1] CGColor];
    
}


-(void)setButtons{
    UIButton *btn5k = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5k.frame = CGRectMake(50, self.view.frame.size.height / 736 * 560, 50, 50);
    [btn5k setImage:[UIImage imageNamed:@"跑步0.png"] forState:UIControlStateSelected];
    [btn5k setTitle:@"5000步" forState:UIControlStateNormal];
    [btn5k setTitle:@"5000步" forState:UIControlStateHighlighted];
    [btn5k setImage:[UIImage imageNamed:@"跑步0_2.png"] forState:UIControlStateNormal];
    [btn5k addTarget:self action:@selector(btn5kAction:) forControlEvents:UIControlEventTouchUpInside];
    _btn5k = btn5k;
    _btn5k.selected = YES;
    [self.view addSubview:btn5k];
    
    UIButton *btn10k = [UIButton buttonWithType:UIButtonTypeCustom];
    btn10k.frame = CGRectMake(self.view.frame.size.width / 3 + 40, self.view.frame.size.height / 736 * 560 , 50, 50);
    [btn10k setImage:[UIImage imageNamed:@"跑步2.png"] forState:UIControlStateSelected];
    [btn10k setTitle:@"10000步" forState:UIControlStateNormal];
    [btn10k setTitle:@"10000步" forState:UIControlStateHighlighted];
    [btn10k setImage:[UIImage imageNamed:@"跑步2_2.png"] forState:UIControlStateNormal];
    [btn10k addTarget:self action:@selector(btn10kAction:) forControlEvents:UIControlEventTouchUpInside];
    _btn10k = btn10k;
    [self.view addSubview:btn10k];
    
    UIButton *btn15k = [UIButton buttonWithType:UIButtonTypeCustom];
    btn15k.frame = CGRectMake(self.view.frame.size.width * 2 / 3 + 30, self.view.frame.size.height / 736 * 560, 50, 50);
    [btn15k setImage:[UIImage imageNamed:@"跑步3.png"] forState:UIControlStateSelected];
    [btn15k setTitle:@"10000步" forState:UIControlStateNormal];
    [btn15k setTitle:@"10000步" forState:UIControlStateHighlighted];
    [btn15k setImage:[UIImage imageNamed:@"跑步3_2.png"] forState:UIControlStateNormal];
    [btn15k addTarget:self action:@selector(btn15kAction:) forControlEvents:UIControlEventTouchUpInside];
    _btn15k = btn15k;
    [self.view addSubview:btn15k];
    UILabel *stepTargetLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,50, 80, 30)];
    stepTargetLabel.text = @"5000步";
    stepTargetLabel.font = [UIFont systemFontOfSize:20];
    [btn5k addSubview:stepTargetLabel];
    
    UILabel *stepTargetLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(-10,50, 80, 30)];
    stepTargetLabel2.text = @"10000步";
    stepTargetLabel2.font = [UIFont systemFontOfSize:20];
    [btn10k addSubview:stepTargetLabel2];
    
    UILabel *stepTargetLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0,50, 80, 30)];
    stepTargetLabel3.text = @"15000步";
    stepTargetLabel3.font = [UIFont systemFontOfSize:20];
    [btn15k addSubview:stepTargetLabel3];
    
    
    UIButton *Mapbutton = [[UIButton alloc]init];
    [Mapbutton addTarget:self action:@selector(PushMap) forControlEvents:UIControlEventTouchUpInside];
    [Mapbutton setBackgroundImage:[UIImage imageNamed:@"mapButton.png"] forState:UIControlStateNormal];
    Mapbutton.frame = CGRectMake(self.view.frame.size.width - 40, 30, 32, 32);
    [self.view addSubview:Mapbutton];
    
    UIButton *historyBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 32, 32, 32)];
    [historyBtn setBackgroundImage:[UIImage imageNamed:@"足迹.png"] forState:UIControlStateNormal];
    [historyBtn addTarget:self action:@selector(historyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:historyBtn];
    
    
}

-(void)historyAction{
    HistoryViewController *history = [[HistoryViewController alloc]init];
    [self.navigationController pushViewController:history animated:YES];
    
}

-(void)btn5kAction:(UIButton *)btn{
    
    _btn5k.selected = YES;
    _btn10k.selected = NO;
    _btn15k.selected = NO;
    _targetStepNumber = 5000;
    _zjlabel.present = _stepNumber * 1.0 / _targetStepNumber;
}
-(void)btn10kAction:(UIButton *)btn{
    _btn5k.selected = NO;
    _btn10k.selected = YES;
    _btn15k.selected = NO;
    _targetStepNumber = 10000;
    _zjlabel.present = _stepNumber * 1.0 / _targetStepNumber;
}
-(void)btn15kAction:(UIButton *)btn{
    _btn5k.selected = NO;
    _btn10k.selected = NO;
    _btn15k.selected = YES;
    _targetStepNumber = 15000;
    _zjlabel.present = _stepNumber * 1.0 / _targetStepNumber;
    
}

-(void)PushMap{
    MapViewController *mapVC = [[MapViewController alloc]init];
    [self.navigationController pushViewController:mapVC animated:YES];
    
}



-(void)nextDay{
    NSNumber *num = [[NSNumber alloc]initWithInteger:_stepNumber];
    [_stepNumberDict setValue:num forKey:_todaydate];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject];
    NSString *path1 = [path stringByAppendingPathComponent:@"stepNumberDataBase.json"];
    [_stepNumberDict writeToFile:path1 atomically:YES];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    NSDateComponents *com = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    _todaydate = [NSString stringWithFormat:@"%ld-%ld-%ld",com.year,com.month,com.day];
    _stepNumber = 0;
    
}







//主动向系统获取数据  暂时不启用
//-(void)getmotionData{
//    CMAccelerometerData *accelerometerData = self.motionManager.accelerometerData;
//    CMAcceleration acceleration = accelerometerData.acceleration;
//
//}


#pragma mark 计步器及其本地持久化设置
-(void)gravityrespondsetting{
    
    self.motionManager = [[CMMotionManager alloc]init];
    self.motionManager.accelerometerUpdateInterval = 0.5;
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        CMAcceleration acceleration = accelerometerData.acceleration;
        //        NSLog(@"%f,%f,%f",acceleration.x,acceleration.y,acceleration.z);
        //计步器判定条件，过于敏感改这里
        if (acceleration.z > -0.6 || acceleration.z < -1.4) {
            self.stepNumber++;
            
            _zjlabel.present = _stepNumber * 1.0 / _targetStepNumber;
            if (_zjlabel.present > 1) {
                _zjlabel.present = 1.0;
            }
            _zjlabel.NowStep = _stepNumber;
        }
        
    }];
    
    if(_stepNumber == 0){
        //以下内容为实现按天保存步数并实现本地持久化
        _stepNumberDict = [[NSMutableDictionary alloc]init];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject];
        NSString *path1 = [path stringByAppendingPathComponent:@"stepNumberDataBase.json"];
        //        NSLog(@"%@",path1);
        NSDictionary *dict0 = [NSDictionary dictionaryWithContentsOfFile:path1];
        if (dict0) {
            [_stepNumberDict setValuesForKeysWithDictionary:dict0];
        }
        //以上完成取出数据;
        NSDate *date = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
        NSDateComponents *com = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
        NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld",com.year,com.month,com.day];
        //        NSLog(@"%@",dateString);  //当前日期字符串
        _todaydate = dateString;
        NSArray *arr = [_stepNumberDict allKeys];
        for (NSString *tempStr in arr) {
            if ([tempStr isEqualToString:dateString]) {
                NSNumber *num =[_stepNumberDict valueForKey:tempStr];
                _stepNumber = [num integerValue];
            }
        }
        //如果当天步数存在，取出
    }
    
    
    //监听日期更新广播，填写昨日数据后重置日期
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextDay) name:UIApplicationSignificantTimeChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self gravityrespondsetting];
    _zjlabel.NowStep = _stepNumber;
    _zjlabel.present = _stepNumber * 1.0 / _targetStepNumber;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
