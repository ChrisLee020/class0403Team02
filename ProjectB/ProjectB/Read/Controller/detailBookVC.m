//
//  detailBookVC.m
//  ProjectB
//
//  Created by lanou on 16/8/3.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "detailBookVC.h"
#import "deataiBookCell.h"
#import "listVC.h"
#import "detailBookModel.h"

@interface detailBookVC ()

@end
static NSString * IdentifierHeader = @"detaibookHeader";
@implementation detailBookVC


-(detailBookModel2 *)model2
{
    if (!_model2) {
        _model2 = [[detailBookModel2 alloc]init];
    }

    return _model2;
}


-(NSMutableArray *)volumeArray
{
    if (!_volumeArray) {
        _volumeArray = [NSMutableArray array];
    }
    return _volumeArray;
}


#pragma mark创建collectionView并设置代理
-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 20);
        //每个cell大小
        flowLayout.itemSize = CGSizeMake((kScreenWidth-30)/2, (kScreenWidth - 350)/2);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 0;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 0;
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
    
   
    
    [self.view addSubview:self.collectionView];
    
    //注册Cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"deataiBookCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"deatal"];
    //注册Header
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:IdentifierHeader];
    
    [self loadData];
   
}

#pragma mark 数据下载
- (void)loadData
{
//    #define newbookListUrl @"http://v2.api.dmzj.com/novel/recentUpdate/0.json"
    NSString *urlstr = [NSString stringWithFormat:@"http://v2.api.dmzj.com/novel/%@.json",self.bookID];
    NSLog(@"urlStr%@",urlstr);
    

    
   [DownLoad downLoadWithUrl:urlstr postBody:nil resultBlock:^(NSData *data) {
       
       if (data)
       {

           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           
           [self.model2 setValuesForKeysWithDictionary:dic];
           NSArray *arr = dic[@"volume"];
           
           for (NSDictionary *dic2 in arr) {
               detailBookModel *model = [[detailBookModel alloc]init];
               [model setValuesForKeysWithDictionary:dic2];

               [self.volumeArray addObject:model];
           }
           //回到主线程刷新
           dispatch_async(dispatch_get_main_queue(), ^{
               
               [self.collectionView reloadData];
               
    
               
           });
       }
     
    }];
    
}











#pragma mark  collectionView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.volumeArray.count;
}

//cell显示设置
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
        static NSString *identify = @"deatal";
        deataiBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    detailBookModel *model = self.volumeArray[indexPath.row];
    cell.label.text = model.volume_name;
    
        return cell;
   }


//设置分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

//Header数据源方法
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    CollectionReusableView *supplementaryView;
  
    if (self.volumeArray)
    {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
            CollectionReusableView *view2 = (CollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:IdentifierHeader forIndexPath:indexPath];
            
            view2.authors.text =self.model2.authors;
            
            NSMutableString *typ = [NSMutableString string];
            for (int i = 0; i < self.model2.types.count; i++) {
                NSString *types = self.model2.types[i];
                
                typ = (NSMutableString *)[typ stringByAppendingString:types];
                
            }
            view2.types.text = typ;
        
            NSString *str =self. model2.cover;
            NSURL *url = [NSURL URLWithString:str];
            [view2.cover sd_setImageWithURL:url];
            
            view2.hot_hits.text = self.model2.hot_hits.stringValue;

            
            view2.subscribe_num.text = self.model2.subscribe_num.stringValue;
            supplementaryView = view2;
            
        }

    }
   //    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
//        MYFooterView *view = (MYFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifierFooter forIndexPath:indexPath];
//        view.footerLabel.text = [NSString stringWithFormat:@"这是Footer:%d",indexPath.section];
//        supplementaryView = view;
//        
//    }
//    
    return supplementaryView;
}

//设置Header大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{


    return CGSizeMake(kScreenWidth, 250);

}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    listVC *vc = [[listVC alloc]init];
  //  vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];


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
