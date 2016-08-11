//
//  RadioViewController.m
//  ProjectB
//
//  Created by Chris on 16/7/30.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioListCell.h"
#import "RadioListUrl.h"
#import "UnitModel.h"
#import "ListDetailModel.h"
#import "ListDetailViewController.h"
#import "SeriesViewController.h"
#import "Masonry.h"
#import "DrawerViewController.h"
#import "LibraryListViewController.h"
#import "RadioDB.h"
#import "PullDownToRefreshView.h"
#import "MBProgressHUD+MJ.h"

@interface RadioViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;

//四季专题频道
@property (nonatomic, strong)NSMutableArray *unitSeasonArray;

//多乐传统评书频道
@property (nonatomic, strong)NSMutableArray *unitTraditionalArray;

//多乐笑话故事频道
@property (nonatomic, strong)NSMutableArray *unitJokeArray;

//火爆王妃
@property (nonatomic, strong)NSMutableArray *unitQueenArray;

@property (nonatomic, strong)RadioDB *radioDB;

//CollectionView布局
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;

//判断辅助属性
@property (nonatomic, assign)BOOL seasonFinsh;

@property (nonatomic, assign)BOOL traditionalFinsh;

@property (nonatomic, assign)BOOL jokeFinsh;

@property (nonatomic, assign)BOOL queenFinsh;



@end

@implementation RadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backGroundSetting];
    
    [self loadDataNoLink];
    
    [self createCollectionView];    //创建CollectionView
    
    [self settingTop];
    
}

#pragma mark   本地数据加载
- (void)loadDataNoLink
{
    NSMutableArray *seasonArray = [self.radioDB selectFormTable:@"season"];
    
    NSMutableArray *traditionalArray = [self.radioDB selectFormTable:@"traditional"];
    
    NSMutableArray *jokeArray = [self.radioDB selectFormTable:@"joke"];
    
    NSMutableArray *queenArray = [self.radioDB selectFormTable:@"queen"];
    
    if (seasonArray.count == 0)
    {
        [self loadData];
    }
    else
    {
        [self.unitSeasonArray addObjectsFromArray: seasonArray];
        
        [self.unitJokeArray addObjectsFromArray: jokeArray];
        
        [self.unitTraditionalArray addObjectsFromArray:traditionalArray];
        
        [self.unitQueenArray addObjectsFromArray:queenArray];
    }
}


#pragma mark   导航栏设置
- (void)settingTop
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = @"聆听生活";
    
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        
        make.top.equalTo(self.view.mas_top).offset(30);
        
    }];
    
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [topBtn setImage:[UIImage imageNamed:@"settingSwitch.png"] forState:UIControlStateNormal];
    
    topBtn.frame = CGRectMake(0, 0, 80, 80);
    
    [topBtn addTarget:self action:@selector(showTheLeftView) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:topBtn];
    
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(20);
        
        make.top.equalTo(self.view.mas_top).offset(25);
        
    }];

}

#pragma mark    懒加载
- (NSMutableArray *)unitSeasonArray
{
    if (!_unitSeasonArray)
    {
        _unitSeasonArray = [NSMutableArray array];
    }
    
    return _unitSeasonArray;
}

- (NSMutableArray *)unitTraditionalArray
{
    if (!_unitTraditionalArray)
    {
        _unitTraditionalArray = [NSMutableArray array];
    }
    
    return _unitTraditionalArray;
}

- (NSMutableArray *)unitJokeArray
{
    if (!_unitJokeArray)
    {
        _unitJokeArray = [NSMutableArray array];
    }
    
    return _unitJokeArray;
}

- (NSMutableArray *)unitQueenArray
{
    if (!_unitQueenArray)
    {
        _unitQueenArray = [NSMutableArray array];
    }
    
    return _unitQueenArray;
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
//    
////    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
////    
////    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
////    
////    effectView.alpha = 1;
////    
////    effectView.frame = [UIScreen mainScreen].bounds;
////    
////    [backGroundLayoutView addSubview:effectView];
//    
//    [self.view addSubview:backGroundLayoutView];
//}

- (void)backGroundSetting
{
    UIImageView *backGroundImage = [[UIImageView alloc] initWithFrame:kScreenMainBounds];
    
    backGroundImage.image = [UIImage imageNamed:@"radioBackGround.jpg"];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    
    effectView.alpha = 0.7;
    
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
                    
                    if (self.seasonFinsh && self.traditionalFinsh && self.jokeFinsh && self.queenFinsh) {
                        
                         [self.collectionView reloadData];
                        
                    }
                   
                    
                });
            
            
            }
        }];
    
//    多乐传统评书
    [DownLoad downLoadWithUrl:duoleListUrl postBody:nil resultBlock:^(NSData *data) {
        if (data)
        {
            
            [self.radioDB createTable:@"traditional"];
            
            [self.radioDB deleteTable:@"traditional"];
            
            [self.unitTraditionalArray removeAllObjects];
            
            NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *dict2 = dict[@"data"];
            
            NSArray *array = dict2[@"list"];
            
            for (NSDictionary *dic in array)
            {
                UnitModel *unitModel = [[UnitModel alloc] init];
                
                [unitModel setValuesForKeysWithDictionary:dic];
                
                [self.unitTraditionalArray addObject:unitModel];
                
                [self.radioDB addModel:unitModel formTable:@"traditional"];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.traditionalFinsh = YES;
                
                if (self.seasonFinsh && self.traditionalFinsh && self.jokeFinsh && self.queenFinsh) {
                    
                    [self.collectionView reloadData];
                    
                }

                
            });
        }
    }];
    
//    多乐笑话频道
    [DownLoad downLoadWithUrl:duoleJokeUrl postBody:nil resultBlock:^(NSData *data) {
        
        if (data)
        {
            [self.radioDB createTable:@"joke"];
            
            [self.radioDB deleteTable:@"joke"];
            
            [self.unitJokeArray removeAllObjects];

            
            NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *dict2 = dict[@"data"];
            
            NSArray *array = dict2[@"list"];
            
            for (NSDictionary *dic in array)
            {
                UnitModel *unitModel = [[UnitModel alloc] init];
                
                [unitModel setValuesForKeysWithDictionary:dic];
                
                [self.unitJokeArray addObject:unitModel];
                
                [self.radioDB addModel:unitModel formTable:@"joke"];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.jokeFinsh = YES;
                
                if (self.seasonFinsh && self.traditionalFinsh && self.jokeFinsh && self.queenFinsh) {
                    
                    [self.collectionView reloadData];
                    
                }

                
            });
        }
        
    }];
    
//    多乐火爆王妃频道
    [DownLoad downLoadWithUrl:duoleQueenUrl postBody:nil resultBlock:^(NSData *data) {
        if (data)
        {
            
            [self.radioDB createTable:@"queen"];
            
            [self.radioDB deleteTable:@"queen"];

            NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *dict2 = dict[@"data"];
            
            NSArray *array = dict2[@"list"];
            
            [self.unitQueenArray removeAllObjects];

            
            for (NSDictionary *dic in array)
            {
                UnitModel *unitModel = [[UnitModel alloc] init];
                
                [unitModel setValuesForKeysWithDictionary:dic];
                
                [self.unitQueenArray addObject:unitModel];
                
                [self.radioDB addModel:unitModel formTable:@"queen"];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.queenFinsh = YES;
                
                if (self.seasonFinsh && self.traditionalFinsh && self.jokeFinsh && self.queenFinsh) {
                    
                    [self.collectionView reloadData];
                    
                }

                
            });
        }
    }];
    
}

#pragma mark   创建CollectionView 与设置布局
- (void)createCollectionView
{
//    布局设置
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.flowLayout.minimumLineSpacing = 2.5;
    
    self.flowLayout.minimumInteritemSpacing = 2.5;
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
//    collectionView设置
   self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 113) collectionViewLayout:self.flowLayout];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.delegate = self;
    
    self.collectionView.dataSource = self;

    
//    注册cell
    UINib *cellNib = [UINib nibWithNibName:@"RadioListCell" bundle:nil];
    
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"radiolist"];
    
//    注册分区头
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"unitSeasonHeader"];
    

    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"unitTraditionalHeader"];
    
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"unitJokeHeader"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"unitQueenHeader"];
    
//    注册分区尾
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
     PullDownToRefreshView *refreshView = [[PullDownToRefreshView alloc] initWithFrame:CGRectMake(0, -60, kScreenWidth, 60)];
    
    [self.collectionView addSubview:refreshView];
    
    __weak PullDownToRefreshView *weakView = refreshView;
    
    refreshView.refreshingBlock = ^(){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [self loadData];
            
            
            [weakView endRefreshing];
            
           // [self.collectionView reloadData];
            
            [MBProgressHUD showSuccess:@"刷新成功"];
            
        });
        
    };
}

#pragma mark  collectionViewDataSource

//设置分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

//设定Item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        return self.unitSeasonArray.count;
    }
    
    if (section == 1)
    {
        return self.unitQueenArray.count;
    }
    
    if (section == 2) {
        return self.unitJokeArray.count;
    }
    
    if (section == 3)
    {
        return self.unitTraditionalArray.count;
    }
   
    
    return 1;
}

//显示Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  RadioListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"radiolist" forIndexPath:indexPath];
    
//    修改Item布局
        CGFloat itemSizeX = kScreenWidth / 3 - 2.5;
    
        CGFloat itemSizeY = kScreenHeight / 3 - 5;
    
        self.flowLayout.itemSize = CGSizeMake(itemSizeX, itemSizeY);
        
        self.collectionView.collectionViewLayout = self.flowLayout;
    
//    cell.layer.borderWidth = 3;
//    
//    cell.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:165 / 255.0 alpha:0.5]);
    
    if (indexPath.section == 3 )
    {
        UnitModel *unitModel = self.unitTraditionalArray[indexPath.item];
        
        cell.title.text = unitModel.title;
        
        //        cell.subTitle.text = @"";
        
        NSDictionary *dict = unitModel.poster_path;
        
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString: dict[@"poster_180_260"]]];
    }
    
    if (indexPath.section == 2 )
    {
        UnitModel *unitModel = self.unitJokeArray[indexPath.item];
        
        cell.title.text = unitModel.title;
        
//        cell.subTitle.text = @"";
        
        NSDictionary *dict = unitModel.poster_path;
        
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString: dict[@"poster_180_260"]]];
    }
    
     else if (indexPath.section == 1 )
    {
        UnitModel *unitModel = self.unitQueenArray[indexPath.item];
        
        cell.title.text = unitModel.title;
        
//        cell.subTitle.text = @"";
        
        NSDictionary *dict = unitModel.poster_path;
        
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString: dict[@"poster_180_260"]]];
    }
    
    
   else if (indexPath.section == 0 )
    {
        UnitModel *unitModel = self.unitSeasonArray[indexPath.item];
        
        cell.title.text = unitModel.name;
        
//        cell.subTitle.text = [NSString stringWithFormat:@"%@个节目", unitModel.program_count.stringValue] ;
        
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:unitModel.cover]];
    }
    
    
        
        return cell;
  
    
   
}


#pragma mark    重用分区头分区尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        UICollectionReusableView *unitHeaderView;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 40)];
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        
        moreBtn.titleLabel.textColor = [UIColor whiteColor];
        
        
        if (indexPath.section == 1)
        {
            unitHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"unitQueenHeader" forIndexPath:indexPath];
            
            unitHeaderView.userInteractionEnabled = YES;
            
            title.text = @"火爆王妃";
            
            title.textColor = [UIColor whiteColor];
            
            [unitHeaderView addSubview:moreBtn];
            
            [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(60, 40));
                
                make.right.equalTo(unitHeaderView.mas_right);
                
                
            }];
            
            [moreBtn addTarget:self action:@selector(moreQueenListShow) forControlEvents:UIControlEventTouchUpInside];
            

        }
        
        if (indexPath.section == 2)
        {
          unitHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"unitJokeHeader" forIndexPath:indexPath];
            
            unitHeaderView.userInteractionEnabled = YES;
            
            title.text = @"笑话故事";
            
            title.textColor = [UIColor whiteColor];
            
            [unitHeaderView addSubview:moreBtn];
            
            [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(60, 40));
                
                make.right.equalTo(unitHeaderView.mas_right);
 
                
            }];
            
            [moreBtn addTarget:self action:@selector(moreJokeListShow) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        if (indexPath.section == 3)
        {
            unitHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"unitTraditionalHeader" forIndexPath:indexPath];
            
            title.text = @"传统评书";
            
            title.textColor = [UIColor whiteColor];
            
            [unitHeaderView addSubview:moreBtn];
            
            [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(60, 40));
                
                make.right.equalTo(unitHeaderView.mas_right);
                
            }];
            
        [moreBtn addTarget:self action:@selector(moreTraditionalListShow) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (indexPath.section == 0)
        {
            unitHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"unitSeasonHeader" forIndexPath:indexPath];
            
            title.text = @"四季专题频道";
            
            title.textColor = [UIColor whiteColor];
        }
        
            [unitHeaderView addSubview:title];
            
            return unitHeaderView;
        
        
    }
    else
    {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        footerView.backgroundColor = [UIColor clearColor];
        
        return footerView;
    }
 
    
}

//设置分区头高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 40);
}

//设置分区尾高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 30);
}

#pragma mark    collectionView代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1)
    {
        UnitModel *unitModel = self.unitQueenArray[indexPath.item];
        
        NSString *url = [NSString stringWithFormat:@"http://a.duole.com/api/audio/get_audio_info?audio_id=%@&show_epsiode=yes", unitModel.duoleID];
        
        SeriesViewController *seriesVC = [[SeriesViewController alloc] init];
        
        seriesVC.urlStr = url;
        
        seriesVC.labelText = unitModel.title;
        
        [self.navigationController pushViewController:seriesVC animated:YES];
    }
    
    if (indexPath.section == 2)
    {
        UnitModel *unitModel = self.unitJokeArray[indexPath.item];
        
        NSString *url = [NSString stringWithFormat:@"http://a.duole.com/api/audio/get_audio_info?audio_id=%@&show_epsiode=yes", unitModel.duoleID];
        
        SeriesViewController *seriesVC = [[SeriesViewController alloc] init];
        
        seriesVC.urlStr = url;
        
        seriesVC.labelText = unitModel.title;
        
        [self.navigationController pushViewController:seriesVC animated:YES];
    }
    
    if (indexPath.section == 3)
    {
        UnitModel *unitModel = self.unitTraditionalArray[indexPath.item];
        
        NSString *url = [NSString stringWithFormat:@"http://a.duole.com/api/audio/get_audio_info?audio_id=%@&show_epsiode=yes", unitModel.duoleID];
        
        SeriesViewController *seriesVC = [[SeriesViewController alloc] init];
        
        seriesVC.urlStr = url;
        
        seriesVC.labelText = unitModel.title;
        
        [self.navigationController pushViewController:seriesVC animated:YES];
    }
    
    if (indexPath.section == 0) {
        
        NSString *url = [NSString stringWithFormat:@"http://radio.sky31.com/api/program?page=1&album_id=%ld", (long)indexPath.item];
        
        UnitModel *unitModel = self.unitSeasonArray[indexPath.item];
        
        ListDetailViewController *listDetailVC = [[ListDetailViewController  alloc] init];
        
        listDetailVC.urlStr = url;
        
        listDetailVC.labelText = unitModel.name;
        
        [self.navigationController pushViewController:listDetailVC animated:YES];
    }
    
}

#pragma mark 按钮实行方法
- (void)showTheLeftView
{
    [[DrawerViewController shareDrawer] openLeftMenu];
}

- (void)moreJokeListShow
{
    LibraryListViewController *library = [[LibraryListViewController alloc] init];
    
    library.bookcase = @"9";
    
    library.labelText = @"笑话故事";
    
    [self.navigationController pushViewController:library animated:YES];
}

- (void)moreTraditionalListShow
{
    LibraryListViewController *library = [[LibraryListViewController alloc] init];
    
    library.bookcase = @"1";
    
    library.labelText = @"传统评书";
    
    [self.navigationController pushViewController:library animated:YES];
}

- (void)moreQueenListShow
{
    LibraryListViewController *library = [[LibraryListViewController alloc] init];
    
    library.bookcase = @"2";
    
    library.labelText = @"火爆王妃";
    
    [self.navigationController pushViewController:library animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
