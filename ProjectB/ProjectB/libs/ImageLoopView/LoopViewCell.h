//
//  LoopViewCell.h
//  图片无限轮播
//
//  Created by Chris on 16/7/23.
//  Copyright © 2016年 kimlee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoopViewCell : UICollectionViewCell

//图片对应字符串
@property (nonatomic, copy)NSString *URLStr;

@property (nonatomic, copy) NSString *titleStr;

@end
