//
//  AppDelegate.m
//  ProjectB
//
//  Created by Chris on 16/7/29.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "AppDelegate.h"
#import "leftMenuViewController.h"
#import "rightTabBarViewController.h"
#import "DrawerViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _MapManager = [[BMKMapManager alloc]init];
    if ([_MapManager start:@"NaGbwc1RMXzqvlDFBoH1ZPAGGPXWRVbG" generalDelegate:self]) {
        NSLog(@"百度地图启动成功");
    }
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    

    
    leftMenuViewController *leftMenuVC = [[leftMenuViewController alloc] init];

    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainTabView" bundle:nil];
    
    UITabBarController *mainTabBarVC = sb.instantiateInitialViewController;
    
    self.window.rootViewController = [DrawerViewController drawerVcWithMainVc:mainTabBarVC leftMenuVc:leftMenuVC leftWidth:kScreenWidth * 0.75];
    
    [self.window makeKeyAndVisible];

    
    

    
    
    
    return YES;
}




@end
