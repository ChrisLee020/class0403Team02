//
//  RadioViewController.h
//  ProjectB
//
//  Created by Chris on 16/7/30.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeriesModel;

@interface RadioViewController : UIViewController

@property (nonatomic, strong)NSMutableArray *detailList;

@property (nonatomic, strong) SeriesModel *type;


@end
