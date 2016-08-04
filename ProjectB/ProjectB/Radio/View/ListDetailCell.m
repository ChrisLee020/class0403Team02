//
//  ListDetailCell.m
//  ProjectB
//
//  Created by Chris on 16/7/30.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "ListDetailCell.h"

@implementation ListDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.title.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
