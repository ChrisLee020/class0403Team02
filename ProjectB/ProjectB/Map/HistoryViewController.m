//
//  HistoryViewController.m
//  ProjectB
//
//  Created by lanou on 16/8/5.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "HistoryViewController.h"
#import "LineChart.h"
#import "day-step_Model.h"
@interface HistoryViewController ()
@property(nonatomic,strong)NSMutableDictionary *dataDict;
@property(nonatomic,strong)LineChart *linechart;
@property(nonatomic,strong)NSMutableArray *LineChartCurrentData;
@property(nonatomic,strong)UILabel *distanceLabel;
@property(nonatomic,strong)UILabel *hotLabel;
@property(nonatomic,strong)UILabel *stepNumberLabel;
@property(nonatomic,strong)UILabel *targetLabel;
@property(nonatomic,strong)UIView *chartView;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backImageView.image = [UIImage imageNamed:@"SportBack.jpg"];
    backImageView.alpha = 1;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.alpha = 0.75;
    effectView.frame = [UIScreen mainScreen].bounds;
    [backImageView addSubview:effectView];
    [self.view addSubview:backImageView];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 30, 32, 32)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"LastWeekBtn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(Backtolast) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject];
    NSString *path1 = [path stringByAppendingPathComponent:@"stepNumberDataBase.json"];
    _dataDict = [NSMutableDictionary dictionaryWithContentsOfFile:path1];
    
    LineChart *zx = [[LineChart alloc]initWithFrame:CGRectMake(20, 70, self.view.bounds.size.width - 20, (self.view.bounds.size.height - 20) * 0.45)];
    zx.DataDict = _dataDict;
    zx.todaynumber = _stepNumber;
    _linechart = zx;
    [zx build];
    [self.view addSubview:zx];
    _LineChartCurrentData = zx.sortedArr;

    
    UIButton *lastWeek = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
//    lastWeek.imageView.image = [UIImage imageNamed:@"LastWeekBtn.png"];
    [lastWeek setImage:[UIImage imageNamed:@"LastWeekBtn.png"] forState:UIControlStateNormal];
    lastWeek.center = CGPointMake(zx.frame.origin.x - 10 , zx.frame.origin.y + zx.frame.size.height / 2 - 4);
    [lastWeek addTarget:self action:@selector(lastweekAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastWeek];
    
    UIButton *nextWeek = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
//    nextWeek.imageView.image = [UIImage imageNamed:@"nextWeekBtn.png"];
    [nextWeek setImage:[UIImage imageNamed:@"nextWeekBtn.png"] forState:UIControlStateNormal];
    nextWeek.center = CGPointMake(zx.frame.origin.x + zx.frame.size.width - 10, zx.frame.origin.y + zx.frame.size.height / 2 - 4 );
    [nextWeek addTarget:self action:@selector(nextweekAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextWeek];
    [self BuildChart];
    [self refreshChart];

}

-(void)BuildChart{
    UIView *chartView = [[UIView alloc]initWithFrame:CGRectMake(55, ((self.view.bounds.size.height - 20) * 0.4) + 135, self.view.bounds.size.width - 120, (self.view.bounds.size.height - 20) * 0.3)];
    chartView.layer.cornerRadius = 10;
    chartView.layer.borderWidth = 1;
    chartView.layer.borderColor = [UIColor colorWithRed:65/255.0 green:154/255.0 blue:223/255.0 alpha:1.0].CGColor;
    UIView *lineview1 = [[UIView alloc]initWithFrame:CGRectMake(0, chartView.bounds.size.height / 2, chartView.bounds.size.width , 1)];
    lineview1.backgroundColor = [UIColor colorWithRed:65/255.0 green:154/255.0 blue:223/255.0 alpha:1.0];
    [chartView addSubview:lineview1];
    UIView *lineview2 = [[UIView alloc]initWithFrame:CGRectMake(chartView.bounds.size.width / 2 , 0, 1, chartView.bounds.size.height)];
    lineview2.backgroundColor = [UIColor colorWithRed:65/255.0 green:154/255.0 blue:223/255.0 alpha:1.0];
    [chartView addSubview:lineview2];
    
    

    
    UIImageView *distanceImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 120) * 0.25 - 24, ((self.view.bounds.size.height - 20) * 0.3) * 0.25 -  40, 48, 48)];
    distanceImage.image = [UIImage imageNamed:@"distance.png"];
    [chartView addSubview:distanceImage];
    _distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 120) * 0.25 - 45, ((self.view.bounds.size.height - 20) * 0.3) * 0.25 + 15, 90, 30)];
    _distanceLabel.text = @"0米";
    _distanceLabel.textAlignment = NSTextAlignmentCenter;
    _distanceLabel.textColor = [UIColor colorWithRed:65/255.0 green:154/255.0 blue:223/255.0 alpha:1.0];
    [chartView addSubview:_distanceLabel];
    
    
    UIImageView *hotImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 120) * 0.75 - 24, ((self.view.bounds.size.height - 20) * 0.3) * 0.25 -  40, 48, 48)];
    hotImage.image = [UIImage imageNamed:@"hot.png"];
    [chartView addSubview:hotImage];
    _hotLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 120) * 0.75 - 45, ((self.view.bounds.size.height - 20) * 0.3) * 0.25 + 15, 90, 30)];
    _hotLabel.text = @"0卡";
    _hotLabel.textAlignment = NSTextAlignmentCenter;
    _hotLabel.textColor = [UIColor colorWithRed:65/255.0 green:154/255.0 blue:223/255.0 alpha:1.0];
    [chartView addSubview:_hotLabel];
    
    
    UIImageView *stepImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 120) * 0.25 - 24, ((self.view.bounds.size.height - 20) * 0.3) * 0.75 -  40, 48, 48)];
    _stepNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 120) * 0.25 - 45, ((self.view.bounds.size.height - 20) * 0.3) * 0.75 + 15, 90, 30)];
    _stepNumberLabel.text = @"0步";
    _stepNumberLabel.textAlignment = NSTextAlignmentCenter;
    _stepNumberLabel.textColor = [UIColor colorWithRed:65/255.0 green:154/255.0 blue:223/255.0 alpha:1.0];
    [chartView addSubview:_stepNumberLabel];
    
    stepImage.image = [UIImage imageNamed:@"step.png"];
    [chartView addSubview:stepImage];
    UIImageView *targetImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 120) * 0.75 - 24, ((self.view.bounds.size.height - 20) * 0.3) * 0.75 -  40, 48, 48)];
    targetImage.image = [UIImage imageNamed:@"target.png"];
    [chartView addSubview:targetImage];
    _targetLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 120) * 0.75 - 45, ((self.view.bounds.size.height - 20) * 0.3) * 0.75 + 15, 90, 30)];
    _targetLabel.text = @"0.00%";
    _targetLabel.textAlignment = NSTextAlignmentCenter;
    _targetLabel.textColor = [UIColor colorWithRed:65/255.0 green:154/255.0 blue:223/255.0 alpha:1.0];;
    [chartView addSubview:_targetLabel];
    
    
        self.chartView = chartView;
        [self.view addSubview:_chartView];
    
}


-(void)refreshChart{
    NSInteger count = 0;
    NSInteger percent = 0;
    for (int i = 0; i < _LineChartCurrentData.count; i++) {
        day_step_Model *model = _LineChartCurrentData[i];
        count = count + model.number.integerValue;
        if (model.number.integerValue > _targetNumber) {
            percent++;
        }
    }
    if (count != 0){
        
        _stepNumberLabel.text = [NSString stringWithFormat:@"%ld步",count];
        if (count * 0.7 > 1000) {
            CGFloat A1 = count * 0.7 / 1000;
            _distanceLabel.text = [NSString stringWithFormat:@"%.2f千米",A1];
        }else{
            NSInteger A1 = count * 0.7;
            _distanceLabel.text = [NSString stringWithFormat:@"%ld米",A1];
        }
        CGFloat A2 = count / 14.8;
        _hotLabel.text = [NSString stringWithFormat:@"%.2f卡",A2];
        
        _targetLabel.text = [NSString stringWithFormat:@"%.2f%%",percent * 100.0 / _LineChartCurrentData.count];
        
        [_chartView setNeedsDisplay];

    }
}

-(void)nextweekAction{
    [_linechart nextWeekOrLastWeekWithisNextweek:YES];
    [self refreshChart];
 }

-(void)lastweekAction{
    [_linechart nextWeekOrLastWeekWithisNextweek:NO];
    [self refreshChart];
    
    
}


-(void)Backtolast{
    [self.navigationController popViewControllerAnimated:YES];
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
