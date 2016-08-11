//
//  LibraryListViewController.m
//  ProjectB
//
//  Created by Chris on 16/8/5.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "LibraryListViewController.h"
#import "UnitModel.h"
#import "RadioListCell.h"
#import "Masonry.h"
#import "SeriesViewController.h"
#import "MBProgressHUD+MJ.h"

@interface LibraryListViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong)NSMutableArray *libraryListArray;

@property (nonatomic, assign)int page;

@property (nonatomic, assign)BOOL firstIn;



@end


@implementation LibraryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backGroundSetting];
    
    [self createLayout];
    
    [self loadData];
    
    [self settingTop];
    
}

#pragma mark    懒加载
- (NSMutableArray *)libraryListArray
{
    if (!_libraryListArray)
    {
        _libraryListArray = [NSMutableArray array];
    }
    
    return _libraryListArray;
}

#pragma mark    布局设置
- (void)createLayout
{
    self.page = 0;
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.flowLayout.itemSize = CGSizeMake(kScreenWidth / 3 - 5, kScreenHeight / 3 - 20);
    
    self.flowLayout.minimumLineSpacing = 2.5;
    
    self.flowLayout.minimumInteritemSpacing = 2.5;
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 133) collectionViewLayout:self.flowLayout];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.delegate = self;
    
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"RadioListCell" bundle:nil] forCellWithReuseIdentifier:@"radiolist"];
    
    self.firstIn = NO;
    
}

#pragma mark    背景设置
- (void)backGroundSetting
{
    UIImageView *backGroundImage = [[UIImageView alloc] initWithFrame:kScreenMainBounds];
    
    backGroundImage.image = [UIImage imageNamed:@"radioBackGround.jpg"];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    
    effectView.alpha = 1;
    
    effectView.frame = [UIScreen mainScreen].bounds;
    
    [backGroundImage addSubview:effectView];
    
    [self.view addSubview:backGroundImage];
}


#pragma mark   导航栏设置
- (void)settingTop
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = self.labelText;
    
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        
        make.top.equalTo(self.view.mas_top).offset(30);
        
    }];
    
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [topBtn setImage:[UIImage imageNamed:@"reback.png"] forState:UIControlStateNormal];
    
    topBtn.frame = CGRectMake(0, 0, 80, 80);
    
    [topBtn addTarget:self action:@selector(reback) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:topBtn];
    
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(10);
        
        make.top.equalTo(self.view.mas_top).offset(25);
        
    }];
    
}


#pragma mark    加载数据
- (void)loadData
{
    self.page++;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://a.duole.com/api/audio/get_lastest_book_list?category=%@&show_epsiode=no&page=%d&limit=18", self.bookcase, self.page];
    
    [DownLoad downLoadWithUrl:urlStr postBody:nil resultBlock:^(NSData *data) {
        
        if (data)
        {
         
            NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *dict2 = dict[@"data"];
            
            NSArray *array = dict2[@"list"];
            
            for (NSDictionary *dic in array)
            {
                UnitModel *unitModel = [[UnitModel alloc] init];
                
                [unitModel setValuesForKeysWithDictionary:dic];
                
                [self.libraryListArray addObject:unitModel];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
               
                if (self.firstIn)
                {
                    [MBProgressHUD hideHUD];
                    
                    [MBProgressHUD showSuccess:@"加载成功"];

                }
                
                self.firstIn = YES;

                
            });
       }
        else
        {
            [MBProgressHUD hideHUD];
            
            [MBProgressHUD showSuccess:@"加载失败"];
        }
   }];
}

#pragma mark    collectionViewDataSource
//设置Item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.libraryListArray.count;
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RadioListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"radiolist" forIndexPath:indexPath];

    UnitModel *model = self.libraryListArray[indexPath.item];
    
    cell.title.text = model.title;
    
    NSDictionary *dict = model.poster_path;
    
    [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:dict[@"poster_180_260"]]];

    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    按钮方法
- (void)reback
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark    collectionView代理方法
//结束拖拽方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat height = kScreenHeight;
    
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - height + 80)
    {
        
        [MBProgressHUD showMessage:@"正在加载"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadData];

        });
            
     
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UnitModel *unitModel = self.libraryListArray[indexPath.item];
    
    NSString *url = [NSString stringWithFormat:@"http://a.duole.com/api/audio/get_audio_info?audio_id=%@&show_epsiode=yes", unitModel.duoleID];
    
    SeriesViewController *seriesVC = [[SeriesViewController alloc] init];
    
    seriesVC.urlStr = url;
    
    seriesVC.labelText = unitModel.title;
    
    [self.navigationController pushViewController:seriesVC animated:YES];

}



@end
