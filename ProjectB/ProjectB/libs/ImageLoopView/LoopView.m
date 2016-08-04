//
//  LoopView.m
//  图片无限轮播
//
//  Created by Chris on 16/7/23.
//  Copyright © 2016年 kimlee. All rights reserved.
//

#import "LoopView.h"
#import "LoopViewLayout.h"
#import "LoopViewCell.h"
#import "WeakTimerTargetObject.h"

@interface LoopView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak)UICollectionView *collectionView;

//分页显示
@property (nonatomic, strong)UIPageControl *pageControl;

//定时器
@property (nonatomic, weak) NSTimer *timer;

//图片数组
@property (nonatomic, strong)NSArray *URLStrs;

//标题数组
@property (nonatomic, strong)NSArray *titles;

@end

@implementation LoopView

/**
 *  初始化方法
 *
 *  @param URLStr 图片数组(数组中装的都是图片URL字符串)
 *  @param titles 标题数组
 *
 *  @return 轮播器对象
 */
- (instancetype) initWithURLStrs:(NSArray *)URLStrs titles:(NSArray *)titles
{
    if (self = [super init])
    {
//        创建CollectionView
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[LoopViewLayout alloc] init]];
        
        
        
//        设置背景
        collectionView.backgroundColor = [UIColor orangeColor];
        
//        注册一个cell
        [collectionView registerClass:[LoopViewCell class] forCellWithReuseIdentifier:@"cell"];
        
//        设置数据源
        collectionView.dataSource = self;
        
//        设置代理
        collectionView.delegate = self;
        
//        将collectionView添加到当前控件上
        [self addSubview:collectionView];
        
        self.collectionView = collectionView;
        
//        记录数组
        self.URLStrs = URLStrs;
        
     //  self.titles = titles;
        
        NSLog(@"%@", URLStrs);
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            在主线程空闲的时候执行Block里面的代码
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.URLStrs.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            
//            添加定时器, 每隔1秒切换下一张图片
             [self addTimer];
            
        });
        
        
        
        
        
    }
    
    return self;
}



#pragma mark - 定时器方法

//添加定时器
- (void)addTimer
{
//    创建定时器
    if (self.timer)
    {
        return;
    }
 
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

//移除定时器
- (void)removeTimer
{
    [self.timer invalidate];
    
    self.timer = nil;
}

//定时器回调
- (void)nextImage
{
//    NSLog(@"%s", __FUNCTION__);
    
//    获得当前显示的页号
    //    获得偏移量
    CGFloat offsetX = self.collectionView.contentOffset.x;
    
    //    计算当前显示的页号
    NSInteger page = offsetX / self.collectionView.bounds.size.width;
    
//    设置偏移量
    [self.collectionView setContentOffset:CGPointMake((page + 1) * self.collectionView.bounds.size.width, 0) animated:YES];
}

#pragma mark - UICollectionView 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  
    return self.URLStrs.count  * 3;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
//    从缓存池获得cell
   LoopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:(float)arc4random_uniform(256) / 255.0 blue:(float)arc4random_uniform(256) / 255.0 alpha:1.0];
    
    
    
//    传递URL字符串
//    item > 3    4
    cell.URLStr = self.URLStrs[indexPath.item % self.URLStrs.count];
    
//    传递title字符串
//    cell.titleStr = self.titles[indexPath.item % self.titles.count];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate 代理方法

//当用户开始拖拽时调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

//当自动播放停止滚动动画时调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}


//滑动减速时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    获得偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
//    计算当前显示的页号
    NSInteger page = offsetX / scrollView.bounds.size.width;
    
//    NSLog(@"page = %zd", page);
    
    self.pageControl.currentPage = page % self.URLStrs.count;
    
//        滚动到第0张图片
    if (page == 0)
    {
//        修改collectionView的偏移量
        page = self.URLStrs.count;
        
        self.collectionView.contentOffset = CGPointMake(page * self.collectionView.frame.size.width, 0);
        
    }
    else if (page == [self.collectionView numberOfItemsInSection:0] - 1)
    {
        page = self.URLStrs.count - 1;
        
        self.collectionView.contentOffset = CGPointMake(page * self.collectionView.frame.size.width, 0);
    }
    
    [self addTimer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    设置frame
    self.collectionView.frame = self.bounds;
    
    //        创建页数显示
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30)];
    
    [self addSubview:self.pageControl];
    
    self.pageControl.numberOfPages = self.URLStrs.count;
}

@end
