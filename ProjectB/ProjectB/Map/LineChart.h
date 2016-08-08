//
//  LineChart.h
//  ProjectB
//
//  Created by lanou on 16/8/5.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface LineChart : UIView

@property(nonatomic,strong)NSDictionary *DataDict;  //总计多少天的折线

-(instancetype)initWithFrame:(CGRect)frame;

-(void)buildLine;
-(void)build;
@end
