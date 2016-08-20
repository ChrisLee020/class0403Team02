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
@property(nonatomic,strong)BMKUserLocation *userLocation;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationSer = [[BMKLocationService alloc]init];
    _locationSer.delegate = self;
    [_locationSer startUserLocationService]; //启动定位服务
    self.view.backgroundColor = [UIColor whiteColor];
    //    //地图显示代码
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height * 0.55)];
    
    //    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    //    _mapView.center = self.view.center;
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
    [_locationSer startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.delegate = self;
    [self buildBtn];

    
}


-(void)buildBtn{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 30, 32, 32)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(Backtolast) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    UIButton *SatelliteBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, self.view.frame.size.width + 80, 48 , 48)];
    [SatelliteBtn addTarget:self action:@selector(SatelliteAction:) forControlEvents:UIControlEventTouchUpInside];
    [SatelliteBtn setImage:[UIImage imageNamed:@"satellite.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:SatelliteBtn];
    
    UIButton *indoorBtn = [[UIButton alloc]initWithFrame:CGRectMake(120, self.view.frame.size.width + 80, 48 , 48)];
    [indoorBtn setImage:[UIImage imageNamed:@"indoor.png"] forState:UIControlStateNormal];
    [indoorBtn addTarget:self action:@selector(indoorAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:indoorBtn];
    
    UIButton *followBtn = [[UIButton alloc]initWithFrame:CGRectMake(200, self.view.frame.size.width + 80, 48 , 48)];
    [followBtn addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    [followBtn setImage:[UIImage imageNamed:@"bei.png"] forState:UIControlStateNormal];
    [self.view addSubview:followBtn];
}
-(void)followAction:(UIButton *)btn{
    if (_mapView.userTrackingMode == BMKUserTrackingModeFollowWithHeading) {
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
        [btn setImage:[UIImage imageNamed:@"bei.png"] forState:UIControlStateNormal];
    }else{
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
        [btn setImage:[UIImage imageNamed:@"fangxiang.png"] forState:UIControlStateNormal];
    }
    
    
}


-(void)SatelliteAction:(UIButton *)btn{
    if (_mapView.mapType == BMKMapTypeStandard) {
        [_mapView setMapType:BMKMapTypeSatellite];
        [btn setImage:[UIImage imageNamed:@"cityMode.png"] forState:UIControlStateNormal];
    }else{
        [_mapView setMapType:BMKMapTypeStandard];
        [btn setImage:[UIImage imageNamed:@"satellite.png"] forState:UIControlStateNormal];
    }

    
}
-(void)indoorAction:(UIButton *)btn{
    if (!_mapView.baseIndoorMapEnabled) {
        [btn setImage:[UIImage imageNamed:@"outdoor.png"] forState:UIControlStateNormal];
            _mapView.baseIndoorMapEnabled = YES;
        _mapView.trafficEnabled = NO;
    }else{
        [btn setImage:[UIImage imageNamed:@"indoor.png"] forState:UIControlStateNormal];
        _mapView.baseIndoorMapEnabled = NO;
        _mapView.trafficEnabled = YES;
    }
    //热力图功能可用，等待调用
//    _mapView.baiduHeatMapEnabled = !_mapView.baiduHeatMapEnabled;
}

-(void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
//    NSLog(@"heading is %@",userLocation.heading);
    [_mapView updateLocationData:userLocation];
}
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
//    NSLog(@"location is %f   %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

-(void)Backtolast{
    [self.navigationController popViewControllerAnimated:YES];
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
