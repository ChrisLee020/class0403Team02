//
//  SeriesViewController.m
//  ProjectB
//
//  Created by Chris on 16/8/4.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "SeriesViewController.h"
#import "SeriesModel.h"
#import "SeriesHeaderView.h"
#import "PlayViewController.h"
#import "SeriesCell.h"
#import "Masonry.h"
#import "AnimationPresentedProxy.h"
#import "AnimationDismissProxy.h"

@interface SeriesViewController ()<UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *musicListArray; //播放列表

@property (nonatomic, strong)NSMutableArray *titleListArray;  //标题列表

@property (nonatomic, strong)SeriesModel *seriesModel;  //文字图片等数据

@property (nonatomic, strong)SeriesHeaderView *seriesHeaderView;

@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation SeriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backGroundSetting];
    
    [self createLayout];
    
    [self loadData];
    
    [self settingTop];
}

#pragma mark    懒加载
- (NSMutableArray *)musicListArray
{
    if (!_musicListArray)
    {
        _musicListArray = [NSMutableArray array];
    }
    
    return _musicListArray;
}

- (NSMutableArray *)titleListArray
{
    if (!_titleListArray) {
        _titleListArray = [NSMutableArray array];
    }
    
    return _titleListArray;
}


#pragma mark   导航栏设置
- (void)settingTop
{
    self.titleLabel = [[UILabel alloc]init];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.text = self.labelText;
    
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    
    [self.view addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        
        make.top.equalTo(self.view.mas_top).offset(30);
        
    }];
    
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [topBtn setImage:[UIImage imageNamed:@"reback.png"] forState:UIControlStateNormal];
    
    topBtn.frame = CGRectMake(0, 0, 40, 40);
    
    [topBtn addTarget:self action:@selector(reBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:topBtn];
    
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(10);
        
        make.top.equalTo(self.view.mas_top).offset(25);
        
    }];
    
}


#pragma mark    背景设置
//- (void)backGroundSetting
//{
//    UIView *backGroundLayoutView = [[UIView alloc] initWithFrame:kScreenMainBounds];
//    
//    CAGradientLayer *gradientlayer = [CAGradientLayer layer];
//    
//    gradientlayer.frame = kScreenMainBounds;
//    
//    UIColor *color1 = [UIColor colorWithRed:227.0 / 255 green:137.0 / 255 blue:157.0 / 255 alpha:1];
//    
//    UIColor *color3 = [UIColor colorWithRed:36.0 / 255 green:14.0 / 255 blue:50.0 / 255 alpha:1];
//    
//    UIColor *color2 = [UIColor colorWithRed:91.0 / 255 green:48.0 / 255 blue:82.0 / 255 alpha:1];
//    
//    gradientlayer.colors = @[(id)color1.CGColor, (id)color2.CGColor, (id)color3.CGColor];
//    
//    gradientlayer.startPoint = CGPointMake(1, 0);
//    
//    gradientlayer.endPoint = CGPointMake(0, 1);
//    
//    [backGroundLayoutView.layer addSublayer:gradientlayer];
    
    
    
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
//    
//    effectView.alpha = 0.9;
//    
//    effectView.frame = [UIScreen mainScreen].bounds;
//    
//    [backGroundLayoutView addSubview:effectView];
    
//    [self.view addSubview:backGroundLayoutView];
//}

//背景设置第二方案
- (void)backGroundSetting
{
    UIImageView *backGroundImage = [[UIImageView alloc] initWithFrame:kScreenMainBounds];
    
    backGroundImage.image = [UIImage imageNamed:@"radioBackGround.jpg"];
    
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    
        effectView.alpha = 1;
    
        effectView.frame = [UIScreen mainScreen].bounds;
    
    [backGroundImage addSubview:effectView];
    
    [self.view addSubview:backGroundImage];
    
}

#pragma mark    下载数据
- (void)loadData
{
    [DownLoad downLoadWithUrl:self.urlStr postBody:nil resultBlock:^(NSData *data) {
        if (data)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *dict2 = dict[@"data"];
            
            self.seriesModel = [[SeriesModel alloc] init];
            
            [self.seriesModel setValuesForKeysWithDictionary:dict2];
            
            NSArray *array = dict2[@"episode"];
            
            for (NSDictionary *dic in array)
            {
                SeriesModel *seriesModel = [[SeriesModel alloc] init];
                
                [seriesModel setValuesForKeysWithDictionary:dic];
                
                [self.titleListArray addObject:seriesModel.title];
                
                [self.musicListArray addObject: seriesModel.source_url];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
                [self seriesViewGetSetData];
                
            });
        }
    }];
}

#pragma mark    seriesView加载数据
- (void)seriesViewGetSetData
{
//    self.seriesHeaderView.title.text = self.seriesModel.title;
    
    self.seriesHeaderView.author.text = self.seriesModel.author;
    
    self.seriesHeaderView.play.text = self.seriesModel.play;
    
    self.seriesHeaderView.desc.text = self.seriesModel.intro;
    
    self.seriesHeaderView.praise.text = self.seriesModel.praise;
    
    NSDictionary *dict = self.seriesModel.poster_path;
    
    [self.seriesHeaderView.cover sd_setImageWithURL:[NSURL URLWithString:dict[@"poster_180_260"]]];
}

#pragma mark   tableView创建与界面布局
- (void)createLayout
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 113) style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.rowHeight = 35;
    
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.seriesHeaderView = [SeriesHeaderView shareHeaderView];
    
    self.seriesHeaderView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 364);
    
    self.tableView.tableHeaderView = self.seriesHeaderView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SeriesCell" bundle:nil] forCellReuseIdentifier:@"series"];
    
}


#pragma mark  tableViewDataSource
//设置Cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleListArray.count;
}

//设置cell显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeriesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"series"];
    
    cell.title.text = self.titleListArray[indexPath.row];
    
    if (indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

#pragma mark    tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayViewController *playVC = [[PlayViewController alloc] init];
    
    playVC.detailList = self.titleListArray;
    
    playVC.type = self.seriesModel;
    
    playVC.musicList = self.musicListArray;
    
    playVC.number = indexPath.row;
    
    playVC.modalTransitionStyle = UIModalPresentationCustom;
    
    playVC.transitioningDelegate = self;
    
    [self presentViewController:playVC animated:YES completion:nil];
}

#pragma mark    按钮方法
- (void)reBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark    UIViewControllerTransitioningDelegate代理方法

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    AnimationPresentedProxy *presentedProxy = [[AnimationPresentedProxy alloc] init];
    
    return presentedProxy;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    AnimationDismissProxy *dismissedProxy = [[AnimationDismissProxy alloc] init];
    
    return dismissedProxy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}


@end
