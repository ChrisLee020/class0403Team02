//
//  HistoryViewController.m
//  ProjectB
//
//  Created by lanou on 16/8/5.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "HistoryViewController.h"
#import "LineChart.h"
@interface HistoryViewController ()
@property(nonatomic,strong)NSMutableDictionary *dataDict;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backImageView.image = [UIImage imageNamed:@"SportBack.jpg"];
    backImageView.alpha = 0.45;
    [self.view addSubview:backImageView];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 30, 32, 32)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(Backtolast) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject];
    NSString *path1 = [path stringByAppendingPathComponent:@"stepNumberDataBase.json"];
    _dataDict = [NSMutableDictionary dictionaryWithContentsOfFile:path1];
    
    LineChart *zx = [[LineChart alloc]initWithFrame:CGRectMake(10, 100, 394, 250)];
    zx.DataDict = _dataDict;
    zx.todaynumber = _stepNumber;
    [zx build];
    [self.view addSubview:zx];

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
