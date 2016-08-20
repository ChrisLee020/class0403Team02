//
//  RadioViewController.m
//  ProjectB
//
//  Created by Chris on 16/7/30.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "AnimationDismissProxy.h"
#import "AnimationPresentedFade.h"
#import "AnimationDismissTransform.h"
#import "AnimationPresentedProxy.h"
#import "AVManager.h"
#import "DrawerViewController.h"
#import "ListDetailModel.h"
#import "ListDetailViewController.h"
#import "Masonry.h"
#import "MBProgressHUD+MJ.h"
#import "PullDownToRefreshView.h"
#import "PlayViewController.h"
#import "RadioDB.h"
#import "RadioViewController.h"
#import "RadioListCell.h"
#import "RadioListUrl.h"
#import "SeriesModel.h"
#import "UnitModel.h"
#import "YHJTabPageScrollView.h"
#import "SeasonAnchorCell.h"
#import "PlayerShortcutButton.h"



@interface RadioViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource>



//四季专题频道
@property (nonatomic, strong)NSMutableArray *unitSeasonArray;

//四季主播频道
@property (nonatomic, strong)NSMutableArray *unitSeasonAnchorArray;

//电台页面保存
@property (nonatomic, strong)RadioDB *radioDB;

//CollectionView布局
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;

//分页
@property (nonatomic, strong) YHJTabPageScrollView *pageScroll;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UICollectionView *collectionView;

//判断辅助属性
@property (nonatomic, assign)BOOL seasonFinsh;

@property (nonatomic, assign)BOOL seasonAnchorFinsh;


//小播放页

@property (nonatomic, assign, getter = isPlaying)BOOL playing;

@property (nonatomic, strong)PlayerShortcutButton *playerSB;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, strong)AVManager *player;

@property (nonatomic, strong)PlayViewController *playVC;


@end

@implementation RadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backGroundSetting];
    
    [self loadDataNoLink];
    
    [self createLayout];    //创建布局
    
    [self settingTop];

}

#pragma mark   本地数据加载
- (void)loadDataNoLink
{
    NSMutableArray *seasonArray = [self.radioDB selectFormTable:@"season"];
    
    NSMutableArray *seasonAnchorArray = [self.radioDB selectFormTable:@"anchor"];
    
    if (seasonArray.count == 0)
    {
        [self loadData];
    }
    else
    {
        [self.unitSeasonArray addObjectsFromArray: seasonArray];
        
        [self.unitSeasonAnchorArray addObjectsFromArray:seasonAnchorArray];
    }
}


#pragma mark   导航栏设置
- (void)settingTop
{
    self.navigationController.navigationBarHidden = YES;

    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = @"聆听生活";
    
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        
        make.top.equalTo(self.view.mas_top).offset(30);
        
    }];
    
    
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [topBtn setImage:[UIImage imageNamed:@"settingSwitch.png"] forState:UIControlStateNormal];
    
    topBtn.frame = CGRectMake(0, 0, 100, 60);
    
    [topBtn addTarget:self action:@selector(showTheLeftView) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:topBtn];
    
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(20);
        
        make.top.equalTo(self.view.mas_top).offset(25);
        
    }];
    
    UIButton *topRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [topRightBtn setImage:[UIImage imageNamed:@"update.png"] forState:UIControlStateNormal];
    
    topRightBtn.frame = CGRectMake(0, 0, 100, 60);
    
    [topRightBtn addTarget:self action:@selector(dataRefresh) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:topRightBtn];
    
    [topRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-20);
        
        make.top.equalTo(self.view.mas_top).offset(25);
    }];
    
   
}






#pragma mark    懒加载

- (NSMutableArray *)unitSeasonAnchorArray
{
    if (!_unitSeasonAnchorArray)
    {
        _unitSeasonAnchorArray = [NSMutableArray array];
    }
    
    return _unitSeasonAnchorArray;
}

- (NSMutableArray *)unitSeasonArray
{
    if (!_unitSeasonArray)
    {
        _unitSeasonArray = [NSMutableArray array];
    }
    
    return _unitSeasonArray;
}


- (RadioDB *)radioDB
{
    if (!_radioDB)
    {
        _radioDB = [RadioDB shareDataHandler];
    }
    
    return _radioDB;
}

#pragma mark    背景设置


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

#pragma mark    加载数据
- (void)loadData
{

    
//    四季频道
    [DownLoad downLoadWithUrl:unitListUrl postBody:nil resultBlock:^(NSData *data) {
        
            if (data)
            {
                self.seasonFinsh = NO;
                
                [self.radioDB createTable:@"season"];
                
                [self.radioDB deleteTable:@"season"];
                
                [self.unitSeasonArray removeAllObjects];
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSArray *array = dict[@"data"];
                
                for (NSDictionary *dic in array) {
                    UnitModel *unitModel = [[UnitModel alloc] init];
                    
                    [unitModel setValuesForKeysWithDictionary:dic];
                    
                    [self.unitSeasonArray addObject:unitModel];

                    [self.radioDB addModel:unitModel formTable:@"season"];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.seasonFinsh = YES;
                    
                    if (self.seasonFinsh) {
                        
                         [self.collectionView reloadData];
                        
                    }
                   
                    
                });
            
            
            }
        }];
    
    [DownLoad downLoadWithUrl:seasonAnchorUrl postBody:nil resultBlock:^(NSData *data) {
        
        if (data)
        {
            
            self.seasonAnchorFinsh = NO;
            
            [self.radioDB createTable:@"anchor"];
            
            [self.radioDB deleteTable:@"anchor"];
            
            [self.unitSeasonAnchorArray removeAllObjects];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSArray *array = dict[@"data"];
            
            for (NSDictionary *dic in array)
            {
                UnitModel *model = [[UnitModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [self.unitSeasonAnchorArray addObject:model];
                
                [self.radioDB addModel:model formTable:@"anchor"];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.seasonAnchorFinsh = YES;
                
                if (self.seasonAnchorFinsh)
                {
                    [self.tableView reloadData];
                }
                
            });
        }
        
    }];
}




#pragma mark   创建CollectionView 与设置布局
- (void)createLayout
{
    
//    播放栏
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    self.playVC = [PlayViewController sharePlayViewController];
    
    self.player = [AVManager shareInstance];
    
//    tableView设置
    self.tableView = [[UITableView alloc] initWithFrame:kScreenMainBounds style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 80;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SeasonAnchorCell" bundle:nil] forCellReuseIdentifier:@"anchor"];
    
    
//    布局设置
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.flowLayout.itemSize = CGSizeMake((kScreenWidth - 20) / 3 - 10, kScreenHeight / 3 - 50);
    
    self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 3, 10, 3);
    
    self.flowLayout.minimumLineSpacing = 15;
    
    self.flowLayout.minimumInteritemSpacing = 10;
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
//    collectionView设置
   self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight) collectionViewLayout:self.flowLayout];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    self.collectionView.delegate = self;
    
    self.collectionView.dataSource = self;
    
    NSArray *pageItem = @[[[YHJTabPageScrollViewPageItem alloc] initWithTabName:@"专题频道" andTabView:self.collectionView], [[YHJTabPageScrollViewPageItem alloc] initWithTabName:@"主播列表" andTabView:self.tableView]];

    
    self.pageScroll = [[YHJTabPageScrollView alloc] initWithPageItems:pageItem];
    
    self.pageScroll.frame = CGRectMake(10, 64, kScreenWidth - 20, kScreenHeight - 173);
    
    [self.view addSubview:self.pageScroll];
    
    
    PlayerShortcutButton *playerSB = [[[NSBundle mainBundle] loadNibNamed:@"PlayerShortcutButton" owner:nil options:nil]lastObject];
    
    self.playerSB = playerSB;
    
    [self.view addSubview:self.playerSB];
    
    [self.playerSB mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.pageScroll.mas_bottom);
        
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 60));
        
    }];
    

    
//    注册cell
    UINib *cellNib = [UINib nibWithNibName:@"RadioListCell" bundle:nil];
    
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"radiolist"];
    
//    注册分区头
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"unitSeasonHeader"];
    
//    注册分区尾
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
  
    /*
     PullDownToRefreshView *refreshView = [[PullDownToRefreshView alloc] initWithFrame:CGRectMake(0, -60, kScreenWidth, 60)];

    [self.collectionView addSubview:refreshView];
    
    __weak PullDownToRefreshView *weakView = refreshView;
    
    refreshView.refreshingBlock = ^(){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [self loadData];
            
            [weakView endRefreshing];
            
            
        });
        
    };
    
    */
    
 
}


#pragma mark    tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.unitSeasonAnchorArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeasonAnchorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"anchor"];
    
    UnitModel *model = self.unitSeasonAnchorArray[indexPath.row];
    
    NSString *str = [model.avatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:str]];
    
    cell.avatar.layer.cornerRadius = 30;
    
    cell.avatar.layer.masksToBounds = YES;
    
    cell.nickName.text = model.nickname;
    
//    cell.email.text = model.email;
    
    cell.email.text = [NSString stringWithFormat:@"%@个节目", model.program_count];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row % 2 == 0)
    {
//        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        
        cell.backgroundColor = [UIColor clearColor];
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    
    return cell;
}

#pragma mark    tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitModel *model = self.unitSeasonAnchorArray[indexPath.row];
    
    ListDetailViewController *detailVC = [[ListDetailViewController alloc] init];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://radio.sky31.com/api/program?page=1&user_id=%@", model.seasonID];
    
    detailVC.urlStr = urlStr;
    
    detailVC.labelText = model.nickname;
    
    detailVC.modalTransitionStyle = UIModalPresentationCustom;
    
    detailVC.transitioningDelegate = self;
    
    [self presentViewController:detailVC animated:YES completion:nil];
}

#pragma mark  collectionViewDataSource

//设置分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//设定Item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.unitSeasonArray.count;
}

//collectionView显示Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  RadioListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"radiolist" forIndexPath:indexPath];
    
    
    cell.layer.borderWidth = 3;
    
    cell.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:165 / 255.0 alpha:0.5]);
    
        if (indexPath.section == 0 && self.unitSeasonArray.count == 6)
    {
        UnitModel *unitModel = self.unitSeasonArray[indexPath.item];
        
        cell.title.text = unitModel.name;
        
//        cell.subTitle.text = [NSString stringWithFormat:@"%@个节目", unitModel.program_count.stringValue] ;
        
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:unitModel.cover]];
    }
    
    
        
        return cell;
  
    
   
}




//#pragma mark    collectionView重用分区头分区尾
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
//    {
//////
//        UICollectionReusableView *unitHeaderView;
////
//        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 40)];
////
//        if (indexPath.section == 0)
//        {
//            unitHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"unitSeasonHeader" forIndexPath:indexPath];
//            
//            title.text = @"四季专题频道";
//            
//            title.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
//            
//            title.textColor = [UIColor whiteColor];
//        }
//        
//            [unitHeaderView addSubview:title];
//            
//            return unitHeaderView;
//        
        
//    }
//    else
//    {
//        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
//        
//        footerView.backgroundColor = [UIColor clearColor];
//        
//        return footerView;
//    }
 
    
//}

//collectionView设置分区头高度
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(kScreenWidth, 40);
//}

//collectionView设置分区尾高度
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(kScreenWidth, 30);
//}

#pragma mark    collectionView代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        if (indexPath.section == 0)
    {
        
        NSString *url = [NSString stringWithFormat:@"http://radio.sky31.com/api/program?page=1&album_id=%ld", (long)indexPath.item];
        
        UnitModel *unitModel = self.unitSeasonArray[indexPath.item];
        
        ListDetailViewController *listDetailVC = [[ListDetailViewController  alloc] init];
        
        listDetailVC.urlStr = url;
        
        listDetailVC.labelText = unitModel.name;
        
        listDetailVC.modalTransitionStyle = UIModalPresentationCustom;
        
        listDetailVC.transitioningDelegate = self;
        
        [self presentViewController:listDetailVC animated:YES completion:nil];

    }
    
}



#pragma mark 按钮实行方法
//打开侧边栏
- (void)showTheLeftView
{
    [[DrawerViewController shareDrawer] openLeftMenu];
}

//更新数据
- (void)dataRefresh
{
    [MBProgressHUD showMessage:@"更新中"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUD];
        
        [self loadData];
        
    });

}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if ([dismissed isKindOfClass:[PlayViewController class]])
    {
        AnimationDismissProxy *dismissedProxy = [[AnimationDismissProxy alloc] init];
        
        return dismissedProxy;
    }
    else
    {
    
        AnimationDismissTransform *dismissedProxy = [[AnimationDismissTransform alloc] init];
        
        return dismissedProxy;
        
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    if ([presented isKindOfClass:[PlayViewController class]])
    {
        AnimationPresentedProxy *presentedProxy = [[AnimationPresentedProxy alloc] init];
        
        return presentedProxy;
    }
    else
    {
    
        AnimationPresentedFade *presentedFade = [[AnimationPresentedFade alloc] init];
        
        return presentedFade;
    }
    
}


#pragma mark 小播放页
//按钮方法
- (IBAction)playBtn:(id)sender {
    
    self.playing = ![AVManager shareInstance].isPlaying;
    
    if (self.isPlaying)
    {
        [self.player startPlay];
        
        self.playVC.playing = YES;
    }
    else
    {
        [self.player stopPlay];
        
        self.playVC.playing = NO;

    }
}

- (IBAction)nextBtn:(id)sender {
    
    if ([AVManager shareInstance].musicUrls.count > 1)
    {
        [self.player next];
    }
    
}

- (void)timerAction
{
    [self updatePlayerMessage];
    
    [self btnState];
}

- (void)updatePlayerMessage
{
    float playDuration = self.player.playDuration;
    
    NSInteger playDurationA = playDuration / 60;
    
    NSInteger playDurationB = (int)playDuration % 60;
    
    float playCuruentTime = self.player.curuentTime;
    
    NSInteger playCuruentTimeA = playCuruentTime / 60;
    
    NSInteger playCuruentTimeB = (int)playCuruentTime % 60;
    
    self.playerSB.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld",(long)playCuruentTimeA ,(long)playCuruentTimeB, (long)playDurationA, (long)playDurationB];
    
    if (self.playVC.detailList != nil)
    {
        ListDetailModel *model = self.playVC.detailList[self.player.playIndex];
        
        self.playerSB.titleLabel.text = model.title;
        
        [self.playerSB.cover sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    }
    else
    {
        self.playerSB.titleLabel.text = @"随行播放";
        
        self.playerSB.cover.image = [UIImage imageNamed:@"CD.png"];
    }

    UITapGestureRecognizer *playerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showThePlaerView)];
    
    [self.playerSB addGestureRecognizer:playerTap];
    
}

- (void)btnState
{
    if (self.player.isPlaying)
    {
         [self.playerSB.playBtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.playerSB.playBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
}

- (void)showThePlaerView
{
    PlayViewController *playVC = [PlayViewController sharePlayViewController];
    
    playVC.transitioningDelegate = self;
    
    playVC.modalTransitionStyle = UIModalPresentationCustom;
    
    [self presentViewController:playVC animated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self.navigationController.view bringSubviewToFront:self.navigationController.navigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
