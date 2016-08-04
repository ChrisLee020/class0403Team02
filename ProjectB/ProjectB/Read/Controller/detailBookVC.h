//
//  detailBookVC.h
//  ProjectB
//
//  Created by lanou on 16/8/3.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newBookModel.h"
#import "CollectionReusableView.h"

@interface detailBookVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)newBookModel *model;
@property(nonatomic,strong)NSString *hot_hits;
@property(nonatomic,strong)NSString *subscribe_num;
@property(nonatomic,strong)NSMutableArray *volumeAaary;





@end
