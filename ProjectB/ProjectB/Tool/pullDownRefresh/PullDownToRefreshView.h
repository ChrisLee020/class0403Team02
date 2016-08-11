//
//  PullDownToRefreshView.h
//  下拉刷新
//
//  Created by Chris on 16/7/26.
//  Copyright © 2016年 kimlee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshingBlock)();

@interface PullDownToRefreshView : UIView

@property (nonatomic, copy)RefreshingBlock refreshingBlock;

//结束刷新
- (void)endRefreshing;



@end
