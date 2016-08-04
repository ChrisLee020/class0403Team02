//
//  rightTabBarViewController.m
//  ProjectB
//
//  Created by lanou on 16/7/29.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "AppDelegate.h"
#import "rightTabBarViewController.h"
#import <CoreMotion/CoreMotion.h>

#import "ZJLabel.h"
#import "MapViewController.h"

@interface rightTabBarViewController ()

@property(nonatomic,strong)CMMotionManager *motionManager;


@property(nonatomic,assign)NSInteger stepNumber;
@property(nonatomic,strong)NSMutableDictionary *stepNumberDict;
@property(nonatomic,strong)NSString *todaydate;
@property(nonatomic,assign)BOOL iswalking;
@property(nonatomic,assign)NSInteger targetStepNumber;
@property(nonatomic,strong)ZJLabel *zjlabel;

@end

@implementation rightTabBarViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.stepNumber++;
    
    _zjlabel.present = _stepNumber * 1.0 / _targetStepNumber;
    _zjlabel.NowStep = _stepNumber;
    //    NSLog(@"%f",_zjlabel.present);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
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
    
    _targetStepNumber = 100;  //默认目标步数5000，测试时为100
    
    
    
    
    
    
    
    
    
    
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


-(void)applicationWillTerminate:(UIApplication *)application{
    
    NSNumber *num = [[NSNumber alloc]initWithInteger:_stepNumber];
    [_stepNumberDict setValue:num forKey:_todaydate];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject];
    NSString *path1 = [path stringByAppendingPathComponent:@"stepNumberDataBase.json"];
    [_stepNumberDict writeToFile:path1 atomically:YES];
}


//主动向系统获取数据  暂时不启用
-(void)getmotionData{
    CMAccelerometerData *accelerometerData = self.motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    
}


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
