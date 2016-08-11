//
//  MapViewController.m
//  ProjectB
//
//  Created by lanou on 16/8/3.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)BMKLocationService *locationSer;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationSer = [[BMKLocationService alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    //    //地图显示代码
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width)];
    
    //    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    //    _mapView.center = self.view.center;
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
    [_locationSer startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.delegate = self;
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.3];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 30, 32, 32)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(Backtolast) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    UIButton *indoorBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, self.view.frame.size.width + 80, 50, 30)];
    [indoorBtn addTarget:self action:@selector(IndoorAction) forControlEvents:UIControlEventTouchUpInside];
//    indoorBtn.backgroundColor = [UIColor blueColor];
   
    [self.view addSubview:indoorBtn];
    
}

-(void)IndoorAction{
    if (_mapView.mapType == BMKMapTypeStandard) {
        [_mapView setMapType:BMKMapTypeSatellite];
    }else{
        [_mapView setMapType:BMKMapTypeStandard];
    }
}

-(void)Backtolast{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    NSLog(@"heading is %@",userLocation.heading);
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"didupdate User location lat %f, long %f ",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locationSer.delegate = self;
    
    
}

-(void)mapview:(BMKMapView *)mapView baseIndoorMapWithIn:(BOOL)flag baseIndoorMapInfo:(BMKBaseIndoorMapInfo *)info{
    if (flag) {
        //进入室内图
    }else{
        //移除室内图
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locationSer.delegate = nil;
}

@end
