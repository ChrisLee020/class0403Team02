//
//  ReadViewController.m
//  ProjectB
//
//  Created by lanou on 16/7/30.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadCollectionViewCell.h"
#import "FirstSectionCell.h"
#import "ReadModel.h"
#import "MyHeaderView.h"
#import "MyFooterView.h"
#import "NewBookVC.h"
@interface ReadViewController ()

@end
//添加Header Footer可重用标示符
static NSString *const reuseIdentifierHeader = @"MyHeaderCell";
static NSString *const reuseIdentifierFooter = @"MyFooterCell";
@implementation ReadViewController
- (IBAction)newBook:(id)sender {
    NewBookVC *newVC = [[NewBookVC alloc]init];
    [self.navigationController pushViewController:newVC animated:YES];
    
    
}

- (IBAction)findBook:(id)sender {
}

- (IBAction)topBook:(id)sender {
}







//cell数据源懒加载
-(NSMutableArray *)sectionArray
{
    if (!_sectionArray) {
        _sectionArray = [[NSMutableArray alloc]init];
    }
    return _sectionArray;

}
//Header数据源懒加载
-(NSMutableArray *)cellArray
{
    if (!_cellArray) {
        _cellArray = [[NSMutableArray alloc]init];
    }
    return _cellArray;
}
-(NSMutableArray *)sectionImage
{
    if (!_sectionImage) {
        _sectionImage = [[NSMutableArray alloc]init];
    }
    return _sectionImage;
}
-(NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;

}

#pragma mark创建collectionView并设置代理
-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
       flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 20);
        //每个cell大小
        flowLayout.itemSize = CGSizeMake((kScreenWidth-40)/3, (kScreenWidth - 40)/3+50);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 5;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 10;
        //定义每个UICollectionView 的边距距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 5, 5);//上左下右
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
    }
    return _collectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brownColor];
    [self.view addSubview:self.collectionView];
    
    //注册Cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ReadCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"readcell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FirstSectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"firstcell"];
    
    //注册Header Footer
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifierFooter];
    
    //调用加载数据的方法
    [self loadData];
    
    for (int i = 0; i <5  ;i++ ) {
        NSString *str = [NSString stringWithFormat:@"%d.png",i];
        [self.sectionImage addObject:str];
    }
}



#pragma mark    加载数据
- (void)loadData
{
    [DownLoad downLoadWithUrl:readListUrl postBody:nil resultBlock:^(NSData *data) {
        
        NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
       
   //  [array removeObjectAtIndex:0];
        
        for (NSDictionary *dic in array) {
           NSArray *array = dic[@"data"];
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic2 in array) {
                ReadModel *moel = [[ReadModel alloc]init];
                [moel setValuesForKeysWithDictionary:dic2];
                
                
                
                
                [arr addObject:moel];
            }
            [self.sectionArray addObject:arr];
            
            
            
            
            NSString *str = dic[@"title"];
            [self.cellArray addObject:str];
        }
        NSArray *arr = self.sectionArray[4];
        for (ReadModel *moel in arr) {
          NSString *image = moel.cover;
        [self.images addObject:image];
           
        }
        
        //回到主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    
}


#pragma mark  collectionView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  //  NSArray *arr = _sectionArray[section];
    if (section == 0) {
        return 1;
    }
    return [_sectionArray[section]count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *identify = @"firstcell";
        FirstSectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];

        
        cell.images = self.images;
        NSLog(@"aaaaaaaaaaa%@",cell.images);
        
        LoopView *view = [[LoopView alloc]initWithURLStrs:self.images titles:nil];
        

        view.frame = CGRectMake(0, 0, cell.views.frame.size.width, cell.views.frame.size.height);
        [cell.views addSubview:view];
        
        
        
        
        
        return cell;
    }else{
    
    
    
    
       static NSString *identify = @"readcell";
    ReadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    //设置圆角
    cell.layer.cornerRadius = 8;
    cell.layer.masksToBounds = YES;
    
   NSArray *array = _sectionArray[indexPath.section];
       ReadModel *model = array[indexPath.row];
        NSURL *url = [NSURL URLWithString:model.cover];
    [cell.coverImageView sd_setImageWithURL:url];
    cell.subtitle.text = model.title;
    cell.title.text = model.sub_title;
    
    return cell;
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _sectionArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
      

        return CGSizeMake(kScreenWidth, 375);
    }else{
        
      return  CGSizeMake((kScreenWidth-40)/3, (kScreenWidth - 40)/3+50);

    }


}


#pragma mark 实现Header数据源方法
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *supplementaryView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MyHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader forIndexPath:indexPath];
        
        view.title.text = self.cellArray[indexPath.section];
        NSString *str = self.sectionImage[indexPath.section];
        UIImage *image = [UIImage imageNamed:str];
        view.image.image = image;
        
        supplementaryView = view;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        MyFooterView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifierFooter forIndexPath:indexPath];
        supplementaryView = view;
    
    }

    return supplementaryView;
}
//设置Header大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(kScreenWidth, 40);
}
//设置Footer大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 15);
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
