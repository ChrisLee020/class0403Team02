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
#import "AVManager.h"


@interface AppDelegate ()

@property (nonatomic, strong)AVManager *player;

@end

@implementation AppDelegate

#pragma mark   懒加载播放器
- (AVManager *)player
{
    if (!_player)
    {
        _player = [AVManager shareInstance];
    }
    
    return _player;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    后台播放通道
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    
//    百度地图SDK
    _MapManager = [[BMKMapManager alloc]init];
    if ([_MapManager start:@"NaGbwc1RMXzqvlDFBoH1ZPAGGPXWRVbG" generalDelegate:self]) {
//        NSLog(@"百度地图启动成功");
    }
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    

//    抽屉效果第三方
    leftMenuViewController *leftMenuVC = [[leftMenuViewController alloc] init];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainTabView" bundle:nil];
    
    UITabBarController *mainTabBarVC = sb.instantiateInitialViewController;
//    NSArray *tabBarArr = [mainTabBarVC viewControllers];
//    UIViewController *vc = [tabBarArr objectAtIndex:0];
//    vc.tabBarItem.title = @"健康";
//    vc.tabBarItem.image = [UIImage imageNamed:@"sport.png"];
//    vc = [tabBarArr objectAtIndex:1];
//    vc.tabBarItem.title = @"阅读";
//    vc.tabBarItem.image = [UIImage imageNamed:@"book2.png"];
//    vc = [tabBarArr objectAtIndex:2];
//    vc.tabBarItem.title = @"电台";
//    vc.tabBarItem.image = [UIImage imageNamed:@"listen.png"];
    self.window.rootViewController = [DrawerViewController drawerVcWithMainVc:mainTabBarVC leftMenuVc:leftMenuVC leftWidth:kScreenWidth * 0.75];
    
    [self.window makeKeyAndVisible];

    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    return YES;
}

-(void)applicationWillTerminate:(UIApplication *)application{
    NSNumber *num = [[NSNumber alloc]initWithInteger:*(self.stepNumber)];
    [_stepNumberDictionary setValue:num forKey:_todaydate];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject];
    NSString *path1 = [path stringByAppendingPathComponent:@"stepNumberDataBase.json"];
    //    NSLog(@"%@",path1);
    [_stepNumberDictionary writeToFile:path1 atomically:YES];
    
}
-(void)applicationDidEnterBackground:(UIApplication *)application{
    NSNumber *num = [[NSNumber alloc]initWithInteger:*(self.stepNumber)];
    [_stepNumberDictionary setValue:num forKey:_todaydate];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject];
    NSString *path1 = [path stringByAppendingPathComponent:@"stepNumberDataBase.json"];
//    NSLog(@"%@",path1);
    [_stepNumberDictionary writeToFile:path1 atomically:YES];
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype)
    {
        case UIEventSubtypeRemoteControlPlay:
            [self.player play];
        
            break;
            
        case UIEventSubtypeRemoteControlPause:
            [self.player stopPlay];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [self.player next];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self.player above];
            break;
            
            
        case UIEventSubtypeRemoteControlTogglePlayPause:
            [self.player stopPlay];
            break;
            
        default:
            break;
    }
}

@end
