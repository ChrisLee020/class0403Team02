//
//  DrawerViewController.m
//  仿QQ抽屉效果
//
//  Created by Chris on 16/7/23.
//  Copyright © 2016年 kimlee. All rights reserved.
//

#import "DrawerViewController.h"

@interface DrawerViewController ()

//当前显示的控制器
@property (nonatomic, strong)UIViewController *showingVc;

//遮盖按钮
@property (nonatomic, strong) UIButton *coverBtn;

//主控制器
@property (nonatomic, strong) UIViewController *mainVc;

//左边菜单控制器
@property (nonatomic, strong) UIViewController *leftMenuVc;

//左边菜单控制器最大显示范围
@property (nonatomic, assign) CGFloat leftWidth;

@end

@implementation DrawerViewController

/**
 *  快速创建抽屉控制器
 *
 *  @param mainVC     主控制器 --> UITabBarController
 *  @param leftMenuVc 左边菜单控制器
 *
 *  @return 抽屉控制器
 */

+ (instancetype)drawerVcWithMainVc:(UIViewController *)mainVC leftMenuVc:(UIViewController *)leftMenuVc leftWidth:(CGFloat)leftWidth
{
//    创建抽屉控制器
    DrawerViewController *drawerVC = [[DrawerViewController alloc] init];
    
//    记录属性
    drawerVC.mainVc = mainVC;
    drawerVC.leftWidth = leftWidth;
    drawerVC.leftMenuVc = leftMenuVc;
    
//    将左边菜单控制器的View添加到抽屉控制器的View上
    [drawerVC.view addSubview:leftMenuVc.view];
    
//    将mainVC控制器的View添加到抽屉控制器的View上
    [drawerVC.view addSubview:mainVC.view];
    
//    苹果规定: 如果两个控制器的View互为父子关系, 则这两个控制器也必须为父子关系
    [drawerVC addChildViewController:leftMenuVc];
    [drawerVC addChildViewController:mainVC];
    
//    返回抽屉控制器
    return drawerVC;
}

//获取抽屉控制器
+ (instancetype)shareDrawer
{
    return (DrawerViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}

//打开左边菜单控制器
- (void)openLeftMenu
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.mainVc.view.transform = CGAffineTransformMakeTranslation(self.leftWidth, 0);
        
        self.leftMenuVc.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
//        给mainVc的View添加遮盖按钮
        [self.mainVc.view addSubview:self.coverBtn];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    默认左边控制器的View向左偏移self.leftWidth
    self.leftMenuVc.view.transform = CGAffineTransformMakeTranslation(-self.leftWidth, 0);
    
//    给mainVcDE View设置阴影效果
    self.mainVc.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.mainVc.view.layer.shadowOffset = CGSizeMake(-3, -3);
    
    self.mainVc.view.layer.shadowOpacity = 0.2;
    
    self.mainVc.view.layer.shadowRadius = 5;
    
    if ([self.mainVc isKindOfClass:[UITabBarController class]])
    {
        //    获得tabBarVc的子控制器的View添加边缘拖拽手势
        for (UIViewController *childVc  in self.mainVc.childViewControllers)
        {
            [self addScreenEdgePanGestureRecognizerToView:childVc.view];
        }
    }
    else
    {
        [self addScreenEdgePanGestureRecognizerToView:self.mainVc.view];
    }
    
    
}

//给指定的View添加边缘拖拽手势
- (void)addScreenEdgePanGestureRecognizerToView:(UIView *)view
{
//    创建边缘拖拽手势对象
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(EdgePanGestureRecognizer:)];

//    拖拽方向
    pan.edges = UIRectEdgeLeft;
    
//    添加手势
    [view addGestureRecognizer:pan];
}

//手势识别回调方法
- (void)EdgePanGestureRecognizer: (UIScreenEdgePanGestureRecognizer *)pan
{
//    NSLog(@"%s", __FUNCTION__);
    
//    获取屏幕宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
//    获得x方向拖拽的距离
    CGFloat offSetX = [pan translationInView:pan.view].x;
    
//    判断手势是否结束或者被取消了
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled)
    {
//        判断主控制器的View的X有没有超过屏幕一半
        if (self.mainVc.view.frame.origin.x > screenW * 0.5)
        {
            [self openLeftMenu];
        }
        else
        {
            [self coverBtnClick];
        }
    }
    else if(pan.state == UIGestureRecognizerStateChanged)
    {
//        手势一直在识别中
        self.mainVc.view.transform = CGAffineTransformMakeTranslation(MIN(offSetX, self.leftWidth), 0);
        
        self.leftMenuVc.view.transform = CGAffineTransformMakeTranslation(MIN(-self.leftWidth + offSetX, 0), 0);
        
    }
}

//监听遮盖按钮的拖拽手势
- (void)panCoverBtn:(UIPanGestureRecognizer *)pan
{
    
//    获取屏幕宽度
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
//    获得x方向拖拽的距离
    CGFloat offsetX = [pan translationInView:pan.view].x;
    NSLog(@"offsetX = %f", offsetX);

//    如果是往右边拖拽遮盖按钮
    if (offsetX > 0)
    {
        return;
    }
    
//    offsetX = - 100
    
    CGFloat distance = self.leftWidth - ABS(offsetX); // 300 - 100 = 200
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled)
    {
        if (self.mainVc.view.frame.origin.x > screenWidth * 0.5)
        {
            [self openLeftMenu];
        }
        else
        {
            [self coverBtnClick];
        }
    }
    else if(pan.state == UIGestureRecognizerStateChanged)
    {
        
//        手势一直识别中
        self.mainVc.view.transform = CGAffineTransformMakeTranslation(MAX(0, distance), 0);
        
        self.leftMenuVc.view.transform = CGAffineTransformMakeTranslation(MAX(-self.leftWidth, -self.leftWidth + distance), 0);
    }
}

#pragma mark - 懒加载遮盖按钮
- (UIButton *)coverBtn{
    if (_coverBtn == nil)
    {
        _coverBtn = [[UIButton alloc] init];
        
         _coverBtn.frame = self.mainVc.view.bounds;
        
        _coverBtn.backgroundColor = [UIColor clearColor];
        
//        监听按钮的点击
        [_coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
//       创建一个拖拽手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCoverBtn:)];
        
        [_coverBtn addGestureRecognizer:pan];
    }
    
    return _coverBtn;
}


//监听按钮点击
- (void)coverBtnClick{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
//    CGAffineTransformIdentity:还原View的transfrom
        self.mainVc.view.transform = CGAffineTransformIdentity;
        
        self.leftMenuVc.view.transform = CGAffineTransformMakeTranslation(-self.leftWidth, 0);
        
    } completion:^(BOOL finished) {
        
//        移除遮盖按钮
        [self.coverBtn removeFromSuperview];
        
        self.coverBtn = nil;
        
    }];
     

}


//切换到指定控制器的方法
- (void)switchViewController: (UIViewController *)destVc
{
    destVc.view.frame = self.mainVc.view.bounds;
    
    destVc.view.transform = self.mainVc.view.transform;
    
    self.showingVc = destVc;
    
    [self addChildViewController:destVc];
    
    [self.mainVc.view addSubview:destVc.view];
    
    [self coverBtnClick];
    
//    以动画形式让控制器回到最初状态
    [UIView animateWithDuration:0.25 animations:^{
        destVc.view.transform = CGAffineTransformIdentity;
    }];
}

//切换控制器, 内部自带navigation
- (void)CreateSwitchViewController: (UIViewController *)destVc navigationTitle:(NSString *)str
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:destVc];
    
    nav.topViewController.navigationItem.title = str;
    
   UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backHome)];
    
    nav.topViewController.navigationItem.leftBarButtonItem = leftBarBtn;
    
    nav.view.frame = self.mainVc.view.bounds;
    
    nav.view.transform = self.mainVc.view.transform;
    
    self.showingVc = nav;
    
    [self.view addSubview:nav.view];
    
    [self addChildViewController:nav];
    
    [self coverBtnClick];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        nav.view.transform = CGAffineTransformIdentity;
        
    }];
    
}

//回到主界面
- (void)backHome
{
    [UIView animateWithDuration:0.25 animations:^{
        self.showingVc.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
        
    } completion:^(BOOL finished) {
        
        [self.showingVc.view removeFromSuperview];
        
        self.showingVc = nil;
    }];
}

@end
