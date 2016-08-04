//
//  ZJLabel.h
//  ProjectB
//
//  Created by lanou on 16/8/3.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ZJLabel : UIView

@property(nonatomic,assign)CGFloat present;
@property(nonatomic,strong)UILabel *presentlabel;
@property(nonatomic,assign)NSInteger NowStep;

-(instancetype)initWithFrame:(CGRect)frame;

@end
