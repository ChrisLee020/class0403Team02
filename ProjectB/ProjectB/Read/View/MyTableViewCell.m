//
//  MyTableViewCell.m
//  ProjectB
//
//  Created by lanou on 16/8/3.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *cellID = @"cell";
    MyTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyTableViewCell" owner:self options:nil]lastObject];
    }

    return cell;


}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
