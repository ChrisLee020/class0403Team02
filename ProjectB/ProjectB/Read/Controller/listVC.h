//
//  listVC.h
//  ProjectB
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newBookModel.h"


@interface listVC : UITableViewController


@property(nonatomic,strong)newBookModel *model;
@property(nonatomic,strong)NSMutableArray *sectionArray;
@property(nonatomic,strong)NSMutableArray *headerTitle;


@end
