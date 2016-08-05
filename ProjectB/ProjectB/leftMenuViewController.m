//
//  leftMenuViewController.m
//  ProjectB
//
//  Created by lanou on 16/7/29.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "leftMenuViewController.h"

@interface leftMenuViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableview;

@end

@implementation leftMenuViewController

-(instancetype)init{
    
    self = [super init];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.75, [UIScreen mainScreen].bounds.size.height);
    return self;
    
}




- (void)viewDidLoad {
    UIImageView *backImage = [[UIImageView alloc]init];
    backImage.image = [UIImage imageNamed:@"MenuBackImage.jpg"];
    backImage.frame = self.view.frame;
    backImage.alpha = 0.7;
    [self.view addSubview:backImage];
    [super viewDidLoad];
    [self BuildTableView];
    [self buildheadView];
}

#pragma mark tableview相关
-(void)BuildTableView{
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.3, self.view.frame.size.width, self.view.frame.size.height * 0.7) style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    [self.view addSubview:_tableview];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_tableview dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    NSArray *menuArr = @[@"第一项",@"第二项",@"第三项",@"第四项",@"第五项",@"第六项"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = menuArr[indexPath.row];
    cell.textLabel.frame = CGRectMake(30, 0, self.view.frame.size.width - 30, 50);
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //设置选择菜单项后的行为
}

-(void)buildheadView{
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.3)];
    UIImageView *headimage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 64, 64)];
    headimage.image = [UIImage imageNamed:@"userImageplaceholder.png"];
    headimage.layer.cornerRadius = 32;
    [headview addSubview:headimage];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 47, 190, 30)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = @"未登录";
    [self.view addSubview:nameLabel];
    
    
    [self.view addSubview:headview];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
