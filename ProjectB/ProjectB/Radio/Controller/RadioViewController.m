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



@interface RadioViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;

//四季专题频道
@property (nonatomic, strong)NSMutableArray *unitSeasonArray;

//多乐传统评书频道
@property (nonatomic, strong)NSMutableArray *unitTraditionalArray;

//多乐笑话故事频道
@property (nonatomic, strong)NSMutableArray *unitJokeArray;


//CollectionView布局
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;

@end

@implementation RadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createCollectionView];    //创建CollectionView
    
    [self loadData];
    
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

#pragma mark    加载数据
- (void)loadData
{
//    四季频道
    [DownLoad downLoadWithUrl:unitListUrl postBody:nil resultBlock:^(NSData *data) {
        
            if (data)
            {
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSArray *array = dict[@"data"];
                
                for (NSDictionary *dic in array) {
                    UnitModel *unitModel = [[UnitModel alloc] init];
                    
                    [unitModel setValuesForKeysWithDictionary:dic];
                    
                    [self.unitSeasonArray addObject:unitModel];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.collectionView reloadData];
                    
                });
            
            
            }
        }];
    
//    多乐传统评书
    [DownLoad downLoadWithUrl:duoleListUrl postBody:nil resultBlock:^(NSData *data) {
        if (data)
        {
            NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *dict2 = dict[@"data"];
            
            NSArray *array = dict2[@"list"];
            
            for (NSDictionary *dic in array)
            {
                UnitModel *unitModel = [[UnitModel alloc] init];
                
                [unitModel setValuesForKeysWithDictionary:dic];
                
                [self.unitTraditionalArray addObject:unitModel];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
                
            });
        }
    }];
    
//    多乐笑话频道
    [DownLoad downLoadWithUrl:duoleJokeUrl postBody:nil resultBlock:^(NSData *data) {
        
        if (data)
        {
            NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *dict2 = dict[@"data"];
            
            NSArray *array = dict2[@"list"];
            
            for (NSDictionary *dic in array)
            {
                UnitModel *unitModel = [[UnitModel alloc] init];
                
                [unitModel setValuesForKeysWithDictionary:dic];
                
                [self.unitJokeArray addObject:unitModel];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
                
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
   self.collectionView = [[UICollectionView alloc] initWithFrame:kScreenMainBounds  collectionViewLayout:self.flowLayout];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
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
    
//    注册分区尾
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
}

#pragma mark  collectionViewDataSource

//设置分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

//设定Item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.unitJokeArray.count;
    }
    
    if (section == 1)
    {
        return self.unitTraditionalArray.count;
    }
    
    if (section == 2)
    {
        return self.unitSeasonArray.count;
    }
    
    return 1;
}

//显示Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  RadioListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"radiolist" forIndexPath:indexPath];
    
        CGFloat itemSizeX = kScreenWidth / 3 - 2.5;
    
        CGFloat itemSizeY = kScreenHeight / 3 - 5;
    
        self.flowLayout.itemSize = CGSizeMake(itemSizeX, itemSizeY);
        
        self.collectionView.collectionViewLayout = self.flowLayout;
    
    if (indexPath.section == 0)
    {
        UnitModel *unitModel = self.unitJokeArray[indexPath.item];
        
        cell.title.text = unitModel.title;
        
        cell.subTitle.text = @"";
        
        NSDictionary *dict = unitModel.poster_path;
        
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString: dict[@"poster_180_260"]]];
    }
    
    if (indexPath.section == 1)
    {
        UnitModel *unitModel = self.unitTraditionalArray[indexPath.item];
        
        cell.title.text = unitModel.title;
        
        cell.subTitle.text = @"";
        
        NSDictionary *dict = unitModel.poster_path;
        
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString: dict[@"poster_180_260"]]];
    }
    
    
    if (indexPath.section == 2)
    {
        UnitModel *unitModel = self.unitSeasonArray[indexPath.item];
        
        cell.title.text = unitModel.name;
        
        cell.subTitle.text = [NSString stringWithFormat:@"%@个节目", unitModel.program_count];
        
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:unitModel.cover]];
    }
    
    
        
        return cell;
  
    
   
}


//重用分区头和分区尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        UICollectionReusableView *unitHeaderView;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 40)];
        
        if (indexPath.section == 0)
        {
          unitHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"unitJokeHeader" forIndexPath:indexPath];
            
            title.text = @"笑话故事";
        }
        
        if (indexPath.section == 1)
        {
            unitHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"unitTraditionalHeader" forIndexPath:indexPath];
            
            title.text = @"传统评书";

        }
        
        if (indexPath.section == 2)
        {
            unitHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"unitSeasonHeader" forIndexPath:indexPath];
            
            title.text = @"四季专题频道";
        }
        
            [unitHeaderView addSubview:title];
            
            return unitHeaderView;
        
        
    }
    else
    {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        footerView.backgroundColor = [UIColor colorWithRed:112 / 255.0 green:217 /255.0 blue:197 / 255.0 alpha:0.5];
        
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
    
    if (indexPath.section == 0)
    {
        UnitModel *unitModel = self.unitJokeArray[indexPath.item];
        
        NSString *url = [NSString stringWithFormat:@"http://a.duole.com/api/audio/get_audio_info?audio_id=%@&show_epsiode=yes", unitModel.duoleID];
        
        SeriesViewController *seriesVC = [[SeriesViewController alloc] init];
        
        seriesVC.urlStr = url;
        
        [self.navigationController pushViewController:seriesVC animated:YES];
    }
    
    if (indexPath.section == 1)
    {
        UnitModel *unitModel = self.unitTraditionalArray[indexPath.item];
        
        NSString *url = [NSString stringWithFormat:@"http://a.duole.com/api/audio/get_audio_info?audio_id=%@&show_epsiode=yes", unitModel.duoleID];
        
        SeriesViewController *seriesVC = [[SeriesViewController alloc] init];
        
        seriesVC.urlStr = url;
        
        [self.navigationController pushViewController:seriesVC animated:YES];
    }
    
    if (indexPath.section == 2) {
        NSString *url = [NSString stringWithFormat:@"http://radio.sky31.com/api/program?page=1&album_id=%ld", (long)indexPath.item];
        
        
        ListDetailViewController *listDetailVC = [[ListDetailViewController  alloc] init];
        
        listDetailVC.urlStr = url;
        
        
        [self.navigationController pushViewController:listDetailVC animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
