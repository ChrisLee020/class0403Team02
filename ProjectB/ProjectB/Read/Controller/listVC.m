//
//  listVC.m
//  ProjectB
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "listVC.h"
#import "ristModel.h"
@interface listVC ()

@end

@implementation listVC
-(NSMutableArray *)headerTitle
{
    if (!_headerTitle) {
        _headerTitle = [NSMutableArray array];
    }
    return _headerTitle;
}

-(NSMutableArray *)sectionArray
{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 30;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"log"];
    [self loadData];



}


#pragma mark 数据下载
- (void)loadData
{
#define newbookListUrl @"http://v2.api.dmzj.com/novel/recentUpdate/0.json"
    NSString *url = [NSString stringWithFormat:@"http://v2.api.dmzj.com/novel/chapter/%@.json",self.model.bookID];
    NSLog(@"%@",url);
    [DownLoad downLoadWithUrl:url postBody:nil resultBlock:^(NSData *data) {
        
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dic in arr) {
            
            NSMutableArray *modelArray =[NSMutableArray array];
            NSArray *array = dic[@"chapters"];
            for (NSDictionary *dic1 in array) {
                ristModel *model = [[ristModel alloc]init];
                [model setValuesForKeysWithDictionary:dic1];
                [modelArray addObject:model];
            }
            [self.sectionArray addObject:modelArray];
            NSString *str = dic[@"volume_name"];
            [self.headerTitle addObject:str];
        }
        
        
        
        
        
        
        //回到主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];

}














- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return self.headerTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.sectionArray[section]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"log" forIndexPath:indexPath];
    ristModel *model = self.sectionArray[indexPath.section][indexPath.row];
    cell.textLabel.text = model.chapter_name;
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
