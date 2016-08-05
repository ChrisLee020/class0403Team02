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

@interface SeriesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *musicListArray; //播放列表

@property (nonatomic, strong)NSMutableArray *titleListArray;  //标题列表

@property (nonatomic, strong)SeriesModel *seriesModel;  //文字图片等数据

@property (nonatomic, strong)SeriesHeaderView *seriesHeaderView;

@end

@implementation SeriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLayout];
    
    [self loadData];
    
    
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
    self.seriesHeaderView.title.text = self.seriesModel.title;
    
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
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.seriesHeaderView = [SeriesHeaderView shareHeaderView];
    
    self.seriesHeaderView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 364);
    
    self.tableView.tableHeaderView = self.seriesHeaderView;
    
//    self.tableView.frame = CGRectMake(0, 364, self.view.bounds.size.width, self.view.bounds.size.height - 364);

    self.tableView.frame = [UIScreen mainScreen].bounds;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"series"];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"series"];
    
    cell.textLabel.text = self.titleListArray[indexPath.row];
    
    if (indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor colorWithRed:171.0 / 255 green:228.0 / 255 blue:192.0 / 255 alpha:0.59];
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
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
    
    [self.navigationController pushViewController:playVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}


@end
