//
//  SeriesHeaderView.m
//  ProjectB
//
//  Created by Chris on 16/8/4.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "SeriesHeaderView.h"

@implementation SeriesHeaderView

+ (instancetype)shareHeaderView
{
    return [[NSBundle mainBundle] loadNibNamed:@"SeriesHeaderView" owner:nil options:nil][0];
}

- (void)awakeFromNib
{

}

- (void)layoutSubviews
{
    
}

@end
