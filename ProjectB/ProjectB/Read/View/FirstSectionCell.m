//
//  FirstSectionCell.m
//  ProjectB
//
//  Created by lanou on 16/8/1.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "FirstSectionCell.h"
#import "NewBookVC.h"
@implementation FirstSectionCell
- (IBAction)catchBook:(id)sender {
    NewBookVC *newVC = [[NewBookVC alloc]init];
   
    
}



- (NSArray *)images
{
    if (!_images) {
        _images = [NSArray array];
    }
    
    return _images;
}


- (IBAction)findBook:(id)sender {
}
- (IBAction)topBook:(id)sender {
}

- (void)awakeFromNib {
    
   
}

@end
