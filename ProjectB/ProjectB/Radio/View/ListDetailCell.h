//
//  ListDetailCell.h
//  ProjectB
//
//  Created by Chris on 16/7/30.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *cover;

@property (strong, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) IBOutlet UILabel *total_play;

@property (strong, nonatomic) IBOutlet UILabel *auchor;

@property (strong, nonatomic) IBOutlet UIView *backGroundColor;


@end
