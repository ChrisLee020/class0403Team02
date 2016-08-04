//
//  LoopViewCell.m
//  图片无限轮播
//
//  Created by Chris on 16/7/23.
//  Copyright © 2016年 kimlee. All rights reserved.
//

#import "LoopViewCell.h"
#import "UIImageView+WebCache.h"

@interface LoopViewCell ()

@property (nonatomic, weak)UIImageView *iconView;

@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation LoopViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        创建图片
        UIImageView *iconView = [[UIImageView alloc] init];
        
//        创建标题
  //     UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 60, frame.size.width, 30)];
        
//        将图片添加到当前cell
        [self addSubview:iconView];
        
//        将标题添加到当前cell
   //     [self addSubview:titleLabel];
        
        self.iconView = iconView;
        
  //      self.titleLabel = titleLabel;
        
//        self.titleLabel.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
//        
//        self.titleLabel.textColor = [UIColor whiteColor];
//        
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconView.frame = self.bounds;
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    
    self.titleLabel.text = titleStr;
}

- (void)setURLStr:(NSString *)URLStr
{
    _URLStr = URLStr;
    
//    下载图片
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:URLStr]];
}

@end
