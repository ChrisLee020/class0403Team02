//
//  AppDelegate.h
//  ProjectB
//
//  Created by Chris on 16/7/29.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>


@property(nonatomic,strong)BMKMapManager *MapManager;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong)BaseViewController *baseVC;


@end

