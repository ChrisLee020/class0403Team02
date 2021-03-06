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
#import "Masonry.h"
#import "AnimationDismissProxy.h"
#import "AnimationPresentedProxy.h"
#import "AVManager.h"

@interface ListDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong)NSMutableArray *listArray;

@property (nonatomic, strong)NSMutableArray *srcArray;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UIViewController *topVC;

@property (nonatomic, assign)BOOL finsh;


@end

@implementation ListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backGroundSetting];
    
    [self LoadData];
    
    [self tableViewSetting];
    
    [self settingTop];
    
    [self settingBackGestureRecognizer];
    
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
/*
- (void)backGroundSetting
{
    UIView *backGroundLayoutView = [[UIView alloc] initWithFrame:kScreenMainBounds];
    
    CAGradientLayer *gradientlayer = [CAGradientLayer layer];
    
    gradientlayer.frame = kScreenMainBounds;
    
    UIColor *color1 = [UIColor colorWithRed:227.0 / 255 green:137.0 / 255 blue:157.0 / 255 alpha:1];
    
    UIColor *color3 = [UIColor colorWithRed:36.0 / 255 green:14.0 / 255 blue:50.0 / 255 alpha:1];
    
    UIColor *color2 = [UIColor colorWithRed:91.0 / 255 green:48.0 / 255 blue:82.0 / 255 alpha:1];
    
    gradientlayer.colors = @[(id)color1.CGColor, (id)color2.CGColor, (id)color3.CGColor];
    
    gradientlayer.startPoint = CGPointMake(1, 0);
    
    gradientlayer.endPoint = CGPointMake(0, 1);
    
    [backGroundLayoutView.layer addSublayer:gradientlayer];
    
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
//    
//    effectView.alpha = 0.9;
//    
//    effectView.frame = [UIScreen mainScreen].bounds;
//    
//    [backGroundLayoutView addSubview:effectView];
    
    [self.view addSubview:backGroundLayoutView];
}
*/

- (void)backGroundSetting
{
    UIImageView *backGroundImage = [[UIImageView alloc] initWithFrame:kScreenMainBounds];
    
    backGroundImage.image = [UIImage imageNamed:@"69.jpg"];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    
    effectView.alpha = 0.38;
    
    effectView.frame = [UIScreen mainScreen].bounds;
    
    [backGroundImage addSubview:effectView];
    
    [self.view addSubview:backGroundImage];
}

#pragma mark    导航栏设置

- (void)settingTop
{
    self.titleLabel = [[UILabel alloc]init];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.text = self.labelText;
    
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        
        make.top.equalTo(self.view.mas_top).offset(30);
        
    }];
    
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [topBtn setImage:[UIImage imageNamed:@"reback.png"] forState:UIControlStateNormal];
    
    topBtn.frame = CGRectMake(0, 0, 100, 40);
    
    [topBtn addTarget:self action:@selector(reBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:topBtn];
    
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(10);
        
        make.top.equalTo(self.view.mas_top).offset(25);
        
        make.size.mas_equalTo(CGSizeMake(50, 40));
        
    }];
    

}



#pragma mark   加载数据
- (void)LoadData
{
    [DownLoad downLoadWithUrl:self.urlStr postBody:nil resultBlock:^(NSData *data) {
        
        if (data)
        {
            self.finsh = NO;
            
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
                
                self.finsh = YES;
                
                if (self.finsh) {
                    
                    [self.tableView reloadData];
                
                }
               
                
            });
        }
       
        
    }];
}


#pragma mark - Table view data source

- (void)tableViewSetting
{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    
    self.tableView.rowHeight = 100;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    UINib *listDetail = [UINib nibWithNibName:@"ListDetailCell" bundle:nil];
    
    [self.tableView registerNib: listDetail forCellReuseIdentifier:@"listDetail"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listDetail" forIndexPath:indexPath];
    
    
    
    if (self.listArray != nil)
    {
        ListDetailModel *listDetailModel = self.listArray[indexPath.row];
        
        cell.title.text = listDetailModel.title;
        
        cell.total_play.text = listDetailModel.total_play.stringValue;
        
        cell.auchor.text = listDetailModel.author;
        
        [cell.cover sd_setImageWithURL:[NSURL URLWithString:listDetailModel.cover]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [UIColor clearColor];
        

    }
    
    //    设置单双数cell的背景颜色
    if (indexPath.row % 2 == 0)
    {
        cell.backGroundColor.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    else
    {
        cell.backGroundColor.backgroundColor = [UIColor clearColor];
    }
    
    
    return cell;
}

#pragma mark   tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    PlayViewController *playVC = [PlayViewController sharePlayViewController];
    
    playVC.detailList = self.listArray;
    
    playVC.musicList = self.srcArray;
    
    playVC.number = indexPath.row;
    
    playVC.modalTransitionStyle = UIModalPresentationCustom;
    
    playVC.transitioningDelegate = self;
    
    [self presentViewController:playVC animated:YES completion:nil];

}

#pragma mark    按钮方法
- (void)reBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
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


//TODO:修改成模态弹出页面, 手势更改
#pragma mark    返回手势
- (void)settingBackGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(EdgePanGestureRecognizer:)];
    
    pan.edges = UIRectEdgeLeft;
    
    [self.tableView addGestureRecognizer:pan];
}

- (void)EdgePanGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)pan
{
    CGFloat offsetX = [pan translationInView:pan.view].x;
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled)
    {
        if (self.view.frame.origin.x > kScreenWidth * 0.5)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [UIView animateWithDuration:0.5 animations:^{
                
                self.view.transform = CGAffineTransformIdentity;
                
            }];
            
        }
    }
    else if (pan.state == UIGestureRecognizerStateChanged)
    {
      
        self.view.transform = CGAffineTransformMakeTranslation(MIN(offsetX, kScreenWidth), 0);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
