//
//  PlayViewController.h
//  ProjectB
//
//  Created by Chris on 16/8/1.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeriesModel.h"

@interface PlayViewController : UIViewController

@property (nonatomic, strong)NSMutableArray *musicList;

@property (nonatomic, strong)NSMutableArray *detailList;

@property (nonatomic, assign)NSInteger number;

@property (nonatomic, strong)SeriesModel *type;

@property (nonatomic, assign, getter=isPlaying)BOOL playing;

+ (PlayViewController *)sharePlayViewController;

- (IBAction)playBtn:(id)sender;

@end
