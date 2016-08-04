//
//  DrawerViewController.h
//  仿QQ抽屉效果
//
//  Created by Chris on 16/7/23.
//  Copyright © 2016年 kimlee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerViewController : UIViewController

//获取抽屉控制器
+ (instancetype)shareDrawer;

/**
 *  快速创建抽屉控制器
 *
 *  @param mainVC     主控制器 --> UITabBarController
 *  @param leftMenuVc 左边菜单控制器
 *  @param leftWidht  左边菜单控制器显示的最大范围
 *
 *  @return 抽屉控制器
 */

+ (instancetype)drawerVcWithMainVc:(UIViewController *)mainVC leftMenuVc:(UIViewController *)leftMenuVc leftWidth:(CGFloat)leftWidth;

//打开左边菜单控制器
- (void)openLeftMenu;

//切换控制器的方法
- (void)switchViewController: (UIViewController *)destVc;

//回到主界面
- (void)backHome;

//切换控制器, 内部自带navigation
- (void)CreateSwitchViewController: (UIViewController *)destVc navigationTitle:(NSString *)str;

@end
