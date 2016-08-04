//
//  BaseViewController.m
//  ProjectB
//
//  Created by lanou on 16/7/29.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "BaseViewController.h"
#import "RadioViewController.h"
#import "ReadViewController.h"


typedef enum{
    TabBarAtLeft = 0,
    TabBarisMoving = 1,
    TabBarAtRight = 2
}TabBarlocation;



@interface BaseViewController ()

@property(nonatomic,assign)TabBarlocation tabbarlocation;
@property(nonatomic,strong)UIScreenEdgePanGestureRecognizer *pan;
@property(nonatomic,strong)UIPanGestureRecognizer *pan1;
@property(nonatomic,strong)UIView *coverview;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setRootView{
    
    [self.view addSubview: _leftVC.view];
    [self.view addSubview: _rightVC.view];
    _rightVC.view.backgroundColor = [UIColor whiteColor];
    
    
    _pan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(moverightView:)];
    _pan.edges = UIRectEdgeLeft;
    [_rightVC.view addGestureRecognizer:_pan];
    
    
    
    //    UIViewController *secondVC = [[UIViewController alloc]init];
    //    secondVC.view.backgroundColor = [UIColor greenColor];
    //    [_rightVC addChildViewController:secondVC];
    //自己的controller添加的位置在这里，按照上述的三行代码替换为自己的VC，对_rightVC进行addChildVC;
    //let`s rock and roll!
    _tabbarlocation = TabBarAtLeft;  //设置tabBar初始位置在左侧;
    
    //添加read页
    ReadViewController *readVC = [[ReadViewController alloc]init];
    UINavigationController *readNav = [[UINavigationController alloc]initWithRootViewController:readVC];
    [self.rightVC addChildViewController:readNav];
    
    
    //    添加radio页
    RadioViewController *radioVC = [[RadioViewController alloc] init];
    
    UINavigationController *radioNav = [[UINavigationController alloc] initWithRootViewController:radioVC];
    
    [self.rightVC addChildViewController:radioNav];
}


#pragma mark  抽屉移动执行方法
-(void)moverightView:(UIPanGestureRecognizer *)pan{
    
    _tabbarlocation = TabBarisMoving;
    CGPoint A1 = [pan translationInView:_rightVC.view];
    if (A1.x > 0 && pan.view.center.x + A1.x < self.view.bounds.size.width * 1.25 ) {
        pan.view.center = CGPointMake(pan.view.center.x + A1.x, pan.view.center.y);
        [pan setTranslation:CGPointZero inView:_rightVC.view];
    }
    
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        if (_rightVC.view.center.x > [UIScreen mainScreen].bounds.size.width - 50) {
            [UIView animateWithDuration:0.35 animations:^{
                _rightVC.view.frame  = CGRectMake(self.view.bounds.size.width * 0.75, 0, self.view.bounds.size.width , self.view.bounds.size.height);
            } completion:^(BOOL finished) {
                _tabbarlocation = TabBarAtRight;
                if (_coverview == nil) {
                    _coverview = [[UIView alloc]initWithFrame:_rightVC.view.bounds];
                    [_rightVC.view addSubview:_coverview];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverViewtouched)];
                    [_coverview addGestureRecognizer:tap];
                    _coverview.userInteractionEnabled = YES;
                    
                }
                
                _pan1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pantoleft:)];
                [self.rightVC.view addGestureRecognizer:_pan1];
            }];
        }else{
            [UIView animateWithDuration:0.35 animations:^{
                self.rightVC.view.frame = CGRectMake(0, 0, self.view.bounds.size.width , self.view.bounds.size.height);
            } completion:^(BOOL finished) {
                _tabbarlocation = TabBarAtLeft;
                if (_coverview) {
                    [_coverview removeFromSuperview];
                    _coverview = nil;
                }
                [_rightVC.view removeGestureRecognizer:_pan1];
                
            }];
        }
    }
}
//多次添加coverview的BUG已经修复
-(void)pantoleft:(UIPanGestureRecognizer *)pan{
    _tabbarlocation = TabBarisMoving;
    CGPoint A1 = [pan translationInView:_rightVC.view];
    if (A1.x < 0){
        pan.view.center = CGPointMake(pan.view.center.x + A1.x, pan.view.center.y);
        [pan setTranslation:CGPointZero inView:_rightVC.view];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        if (_rightVC.view.center.x > [UIScreen mainScreen].bounds.size.width - 50) {
            [UIView animateWithDuration:0.35 animations:^{
                _rightVC.view.frame  = CGRectMake(self.view.bounds.size.width * 0.75, 0, self.view.bounds.size.width , self.view.bounds.size.height);
            } completion:^(BOOL finished) {
                _tabbarlocation = TabBarAtRight;
                if (_coverview == nil) {
                    _coverview = [[UIView alloc]initWithFrame:_rightVC.view.bounds];
                    [_rightVC.view addSubview:_coverview];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverViewtouched)];
                    [_coverview addGestureRecognizer:tap];
                    _coverview.userInteractionEnabled = YES;
                }
            }];
        }else{
            [UIView animateWithDuration:0.35 animations:^{
                self.rightVC.view.frame = CGRectMake(0, 0, self.view.bounds.size.width , self.view.bounds.size.height);
                if (_pan1) {
                    [_rightVC.view removeGestureRecognizer:_pan1];
                    _pan1 = nil;
                }
                
            } completion:^(BOOL finished) {
                _tabbarlocation = TabBarAtLeft;
                if (_coverview) {
                    [_coverview removeFromSuperview];
                    _coverview = nil;
                }
                
            }];
        }
    }
}

-(void)coverViewtouched{
    
    [UIView animateWithDuration:0.35 animations:^{
        self.rightVC.view.frame = CGRectMake(0, 0, self.view.bounds.size.width , self.view.bounds.size.height);
    } completion:^(BOOL finished) {
        _tabbarlocation = TabBarAtLeft;
        if (_coverview) {
            [_coverview removeFromSuperview];
            _coverview = nil;
        }
        if (_pan1) {
            [_rightVC.view removeGestureRecognizer:_pan1];
            _pan1 = nil;
        }
        
    }];
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
