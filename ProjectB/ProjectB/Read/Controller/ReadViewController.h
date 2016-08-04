//
//  ReadViewController.h
//  ProjectB
//
//  Created by lanou on 16/7/30.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *cellArray;
@property(nonatomic,strong)NSMutableArray *sectionArray;//保存区头
@property(nonatomic,strong)NSMutableArray *sectionImage;
@property(nonatomic,strong)NSMutableArray *images;//轮播图
@end
