//
//  detailBookVC.h
//  ProjectB
//
//  Created by lanou on 16/8/3.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CollectionReusableView.h"
#import "detailBookModel2.h"
@interface detailBookVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;


@property(nonatomic,strong)NSMutableArray *volumeArray;

@property(nonatomic,strong)NSString *bookID;

@property(nonatomic,strong)detailBookModel2 *model2;


@end
