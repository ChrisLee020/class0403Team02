//
//  MyTableViewCell.h
//  ProjectB
//
//  Created by lanou on 16/8/3.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell
+(instancetype) cellWithTableView:(UITableView *)tableview;
@property(nonatomic,strong)NSMutableArray *cellData;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *authors;
@property (strong, nonatomic) IBOutlet UILabel *types;
@property (strong, nonatomic) IBOutlet UILabel *last_update_volume_name;

@end
