//
//  BaseViewController.h
//  ProjectB
//
//  Created by lanou on 16/7/29.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "leftMenuViewController.h"
#import "rightTabBarViewController.h"

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property(nonatomic,strong)leftMenuViewController *leftVC;
@property(nonatomic,strong)UITabBarController *rightVC;

-(void)setRootView;

@end
