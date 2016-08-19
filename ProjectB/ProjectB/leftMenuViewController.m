//
//  leftMenuViewController.m
//  ProjectB
//
//  Created by lanou on 16/7/29.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "leftMenuViewController.h"
#import "LoginViewController.h"
#import "SDImageCache.h"
#import "fileService.h"

@interface leftMenuViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UITextView *textView;


@end

@implementation leftMenuViewController

-(instancetype)init{
    
    self = [super init];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.75, [UIScreen mainScreen].bounds.size.height);
    self.view.backgroundColor = [UIColor clearColor];
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
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_tableview dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    NSArray *menuArr = @[@"第一项",@"清理缓存",@"关于我们"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = menuArr[indexPath.row];
    cell.textLabel.frame = CGRectMake(30, 0, self.view.frame.size.width - 30, 50);
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置选择菜单项后的行为
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 1) {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"确定要清除所有缓存数据么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else if (indexPath.row == 2){
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(40, 50, self.view.bounds.size.width - 40, self.view.bounds.size.height - 100) ];
        textView.text = @"关于本APP的声明\n    本APP是由蓝鸥科技学员在学习过程中为了检验自己的技术水平而制作，所有数据资源来源于网络，如果侵犯到了您的权益，请联系我们，我们会立即删除相关素材。";
        [self.view bringSubviewToFront:textView];
        textView.font = [UIFont systemFontOfSize:30];
        [self.view addSubview:textView];
        textView.userInteractionEnabled = YES;
        _textView = textView;
        UITapGestureRecognizer *textViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeText)];
        [textView addGestureRecognizer:textViewTap];
        
        
    }else{
        
        
    }

}
-(void)removeText{
    [_textView removeFromSuperview];
    _textView = nil;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",buttonIndex);
    if (buttonIndex == 1) {
                NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
                [fileService clearCache:documentPath];
//                NSLog(@"缓存已清除");
    }
}


-(void)buildheadView{
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.16)];
    
    
    UIImageView *headimage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 64, 64)];
    headimage.image = [UIImage imageNamed:@"userImageplaceholder.png"];
    headimage.layer.cornerRadius = 32;
    headimage.layer.masksToBounds = YES;
    headimage.backgroundColor = [UIColor clearColor];
    
    [headview addSubview:headimage];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 47, 190, 30)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = @"未登录";
    [headview addSubview:nameLabel];
    headview.backgroundColor = [UIColor clearColor];
    _imageView = headimage;
    _nameLabel = nameLabel;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoLoginVC:)];

        headview.userInteractionEnabled = YES;
        [headview addGestureRecognizer:tap];

//    nameLabel.userInteractionEnabled = YES;
//    headimage.userInteractionEnabled = YES;
//    [headimage addGestureRecognizer:tap];
//    [nameLabel addGestureRecognizer:tap];
//    [headview bringSubviewToFront:nameLabel];
//    [headview bringSubviewToFront:headimage];
    [self.view addSubview:headview];
}

-(void)gotoLoginVC:(UITapGestureRecognizer *)tap{
    if ([_nameLabel.text isEqualToString:@"未登录"]) {
        UIStoryboard *MapSB = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
        LoginViewController *loginVC = [MapSB instantiateViewControllerWithIdentifier:@"LoginVC"];
        UINavigationController *LoginNavi = [[UINavigationController alloc]initWithRootViewController:loginVC];
        loginVC.namelabel = _nameLabel;
        loginVC.image = _imageView;
        
        [self presentViewController:LoginNavi animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"去往用户信息页面" message:@"等待设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
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
