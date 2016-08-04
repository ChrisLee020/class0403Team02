//
//  LoopView.h
//  图片无限轮播
//
//  Created by Chris on 16/7/23.
//  Copyright © 2016年 kimlee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoopView : UIView

/**
 *  初始化方法
 *
 *  @param URLStr 图片数组(数组中装的都是图片URL字符串)
 *  @param titles 标题数组
 *
 *  @return 轮播器对象
 */
- (instancetype) initWithURLStrs:(NSArray *)URLStrs titles:(NSArray *)titles;

@end
