//
//  PullDownToRefreshView.m
//  下拉刷新
//
//  Created by Chris on 16/7/26.
//  Copyright © 2016年 kimlee. All rights reserved.
//  自定义下拉刷新控件

#import "PullDownToRefreshView.h"
#import "Masonry.h"

//#define PullDownToRefreshViewHeight 60

//自己监听tableView的滚动
//tableView是刷新控件的父控件

//3种状态
typedef enum {
    PullDownToRefreshViewStatusNormal,  //正常状态
    PullDownToRefreshViewStatusPulling, //释放刷新状态
    PullDownToRefreshViewStatusRefreshing   //正在刷新状态
}PullDownToRefreshViewStatus;

@interface PullDownToRefreshView ()

@property (nonatomic, assign)CGFloat height;

//图片
@property (nonatomic, strong)UIImageView *imageView;

//文字
@property (nonatomic, strong)UILabel *label;

//记录当前状态
@property (nonatomic, assign)PullDownToRefreshViewStatus currentStatus;

//父控件, 可以滚动的
@property (nonatomic, strong)UIScrollView *superScrollView;

//吃包子动画
@property (nonatomic, strong)NSArray *refreshingImage;


@end

@implementation PullDownToRefreshView

//添加子控件
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        
        self.height = frame.size.height;
        
        self.label.textColor = [UIColor whiteColor];
        
//        添加控件
        [self addSubview:self.imageView];
    
        [self addSubview:self.label];
        
        
        
//     设置frame
//        第三方控件Masonry自动约束自适应图层layout
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
         
            make.width.equalTo(@50);

            make.bottom.equalTo(self).offset(-8);
            
            make.right.equalTo(self.mas_centerX).offset(-20);
            
            make.top.equalTo(self).offset(5);

        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@200);
            
            make.height.equalTo(@20);
            
            make.left.equalTo(self.imageView.mas_rightMargin).offset(10);
            
            make.top.equalTo(self).offset(20);
        }];
        
        
    }
    
    return self;
}

- (void)dealloc
{
//    移除KVO监听
    [self.superScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

//控件将要添加到父控件中
- (void)willMoveToSuperview:(UIView *)newSuperview
{
//    可以获取父控件
//    只有父控件能滚动的才去监听
    if ([newSuperview isKindOfClass:[UIScrollView class]])
    {
        self.superScrollView = (UIScrollView *)newSuperview;
        
//        监听父控件的滚动其实就是监听 self.superScrollView 对象的 cotentOffset 属性的改变
        
//        KVO:key-Value observing 键值监听 作用:监听一个对象的属性的改变
        
//        KVO使用:要监听那个对象就用哪个对象调用, addObeserver:forKeyPath:options:context方法
//        参数:
//    addObserver:谁来监听
//    forKeyPath:要监听的属性
        
//    KVO:当监听对象的身上的属性发生改变会调用addObserver 对象的observeValueForKeyPath:ofObject:change:context
        
//        注意:使用KVO和使用通知一样需要取消
        [self.superScrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
        
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
//    NSLog(@"%f", self.superScrollView.contentOffset.y);
//    根据拖动的程序切换状态

    if (self.superScrollView.isDragging && self.currentStatus != PullDownToRefreshViewStatusRefreshing)
    {
//    手拖动:normal -> pulling, pulling -> normal
        CGFloat normalPullingOffset = - (40 + self.height);
        if (self.currentStatus != PullDownToRefreshViewStatusNormal && self.superScrollView.contentOffset.y > normalPullingOffset)
        {
    
//            切换到Normal
            self.currentStatus = PullDownToRefreshViewStatusNormal;
        }
        else if (self.currentStatus != PullDownToRefreshViewStatusPulling && self.superScrollView.contentOffset.y <= normalPullingOffset)
        {

//            切换到Pulling
            self.currentStatus = PullDownToRefreshViewStatusPulling;
        }
    }
    else
    {
//    手松开:pulling -> refreshing
        if (self.currentStatus == PullDownToRefreshViewStatusPulling)
        {
//            切换到Refreshing
            self.currentStatus = PullDownToRefreshViewStatusRefreshing;
        }
    }
}

- (void)setCurrentStatus:(PullDownToRefreshViewStatus)currentStatus
{
    _currentStatus = currentStatus;
    
//    设置内容
    switch (_currentStatus)
    {
        case PullDownToRefreshViewStatusNormal:
            
            [self.imageView stopAnimating];
            
            self.label.text = @"下拉刷新";
            
            self.imageView.image = [UIImage imageNamed:@"happy01.tiff"];
            
            break;
            
        case PullDownToRefreshViewStatusPulling:
            
            self.label.text = @"释放刷新";
            
            self.imageView.image = [UIImage imageNamed:@"walking01.tiff"];
            
            break;
            
        case PullDownToRefreshViewStatusRefreshing:
            
            self.label.text = @"正在刷新";
            
            //TODO:动画实现
            
            self.imageView.animationImages = self.refreshingImage;
            self.imageView.animationDuration = 0.1 * self.refreshingImage.count;
            
            [self.imageView startAnimating];
            
//            tableView往下面走
         [UIView animateWithDuration:0.25 animations:^{
              self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top + self.height, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.right);
         }];
           
//            让控制器去做事情
            /*
             Block使用:
             1、定义Block
             2、传递Block
             3、调用Block
             */
            if (self.refreshingBlock)
            {
                self.refreshingBlock();
            }
            
            
            break;
            
    }
}

- (void)endRefreshing
{
//    Refreshing -> Normal
//    tableView回去
    if (self.currentStatus == PullDownToRefreshViewStatusRefreshing)
    {
        self.currentStatus = PullDownToRefreshViewStatusNormal;
        
        self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top - self.height, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.right);
    }
}

#pragma mark - 懒加载

//getter
- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
//        创建图片
        UIImage *normalImage = [UIImage imageNamed:@"happy01.tiff"];
        
        _imageView = [[UIImageView alloc] initWithImage:normalImage];
    }
    
    return _imageView;
}

- (UILabel *)label
{
    if (_label == nil)
    {
        _label = [[UILabel alloc] init];
    
//        设置
        _label.textColor = [UIColor darkGrayColor];
        
        _label.font = [UIFont systemFontOfSize:16];
        
        _label.text = @"下拉刷新";
    }
    
    return _label;
}

//刷新图片懒加载方法
- (NSArray *)refreshingImage
{
    if (_refreshingImage == nil)
    {
        NSMutableArray *arrayM = [NSMutableArray array];
        
        for (int i = 1; i <= 8; i++)
        {
            NSString *imageName =[NSString stringWithFormat:@"walking0%d.tiff",i];
            
            UIImage *image = [UIImage imageNamed:imageName];
            
            [arrayM addObject:image];
        }
        
        _refreshingImage = arrayM;
    }
    
    return _refreshingImage;
    
    
}

@end
