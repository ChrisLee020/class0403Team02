//
//  ListDetailViewController.m
//  ProjectB
//
//  Created by Chris on 16/7/30.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "ListDetailViewController.h"
#import "listDetailCell.h"
#import "ListDetailModel.h"
#import "PlayViewController.h"

@interface ListDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *listArray;

@property (nonatomic, strong)NSMutableArray *srcArray;

@end

@implementation ListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self LoadData];
    
    [self tableViewSetting];
    
}

#pragma mark  懒加载
- (NSArray *)listArray
{
    if (!_listArray)
    {
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
}

- (NSMutableArray *)srcArray
{
    if (!_srcArray)
    {
        _srcArray = [NSMutableArray array];
    }
    
    return _srcArray;
}

#pragma mark    背景加载
- (void)backGroundSetting
{
    
}

#pragma mark   加载数据
- (void)LoadData
{
    [DownLoad downLoadWithUrl:self.urlStr postBody:nil resultBlock:^(NSData *data) {
        
        if (data)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *array = dict[@"data"];
            
            for (NSDictionary *dic in array)
            {
                ListDetailModel *listDetailModel = [[ListDetailModel alloc] init];
                
                [listDetailModel setValuesForKeysWithDictionary:dic];
                
                [self.listArray addObject:listDetailModel];
                
                NSDictionary *srcDict = listDetailModel.audio;
                
                NSString *src = srcDict[@"src"];
                
                [self.srcArray addObject:src];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
            });
        }
       
        
    }];
}


#pragma mark - Table view data source

- (void)tableViewSetting
{
    self.tableView.rowHeight = 100;
    
    UINib *listDetail = [UINib nibWithNibName:@"ListDetailCell" bundle:nil];
    
    [self.tableView registerNib: listDetail forCellReuseIdentifier:@"listDetail"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listDetail" forIndexPath:indexPath];
    
    ListDetailModel *listDetailModel = self.listArray[indexPath.row];
    
    cell.title.text = listDetailModel.title;
    
    cell.total_play.text = listDetailModel.total_play.stringValue;
    
    cell.auchor.text = listDetailModel.author;
    
    [cell.cover sd_setImageWithURL:[NSURL URLWithString:listDetailModel.cover]];
    
//    设置单双数cell的背景颜色
    if (indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:206 / 255.0 blue:170 / 255.0 alpha:0.6];
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    
    return cell;
}

#pragma mark   tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PlayViewController *playVC = [[PlayViewController alloc] init];
    
    playVC.detailList = self.listArray;
    
    playVC.musicList = self.srcArray;
    
    playVC.number = indexPath.row;
    
    [self.navigationController pushViewController:playVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
