//
//  HistoryViewController.m
//  ProjectB
//
//  Created by lanou on 16/8/5.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

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
//    你要的炫酷，可以，这很清真
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
//    label.text = @"炫酷";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:55];
//    label.center = self.view.center;
//    [self.view addSubview:label];
    
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
