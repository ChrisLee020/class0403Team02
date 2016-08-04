//
//  NewBookVC.m
//  ProjectB
//
//  Created by lanou on 16/8/3.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "NewBookVC.h"
#import "MyTableViewCell.h"
#import "newBookModel.h"
#import "detailBookVC.h"
@interface NewBookVC ()

@end

@implementation NewBookVC

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 150;
    [self loadData];
}

#pragma mark 数据下载
- (void)loadData
{
    [DownLoad downLoadWithUrl:newbookListUrl postBody:nil resultBlock:^(NSData *data) {
        
        NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        
        
        NSLog(@"111111111111%@",array);
        for (NSDictionary *dic in array) {
            newBookModel *model = [[newBookModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            NSLog(@"dddddddd%@",model.name);
            [self.dataArray addObject:model];
        
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [MyTableViewCell cellWithTableView:tableView];
    newBookModel *model = self.dataArray[indexPath.row];
    NSString *str = model.cover;
    NSURL *url = [NSURL URLWithString:str];
    [cell.image sd_setImageWithURL:url];
    cell.name.text = model.name;
    cell.authors.text = model.authors;
    NSMutableString *typ = [NSMutableString string];
    
    for (int i = 0; i < model.types.count; i++) {
        NSString *types = model.types[i];
       typ = (NSMutableString *)[typ stringByAppendingString:types];

    }
    
    cell.types.text = typ;
    cell.last_update_volume_name.text = model.last_update_volume_name;
    
    
    
      return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailBookVC *detail = [[detailBookVC alloc]init];
    detail.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];



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
