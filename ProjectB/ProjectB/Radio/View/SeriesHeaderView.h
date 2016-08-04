//
//  SeriesHeaderView.h
//  ProjectB
//
//  Created by Chris on 16/8/4.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeriesHeaderView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *cover;

@property (strong, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) IBOutlet UILabel *author;

@property (strong, nonatomic) IBOutlet UILabel *play;

@property (strong, nonatomic) IBOutlet UILabel *desc;

@property (strong, nonatomic) IBOutlet UILabel *praise;



+ (instancetype)shareHeaderView;

@end
