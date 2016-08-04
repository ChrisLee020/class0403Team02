//
//  LoopViewLayout.m
//  图片无限轮播
//
//  Created by Chris on 16/7/23.
//  Copyright © 2016年 kimlee. All rights reserved.
//

#import "LoopViewLayout.h"

@implementation LoopViewLayout

//准备布局时调用
- (void)prepareLayout
{
    [super prepareLayout];
    
//    设置item尺寸
    self.itemSize = self.collectionView.frame.size;
    
//    设置滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
//    设置分页
    self.collectionView.pagingEnabled = YES;
    
    self.minimumInteritemSpacing = 0;
    
    self.minimumLineSpacing = 0;
    
//    设置隐藏水平滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

@end
