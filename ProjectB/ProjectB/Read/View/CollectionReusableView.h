//
//  CollectionReusableView.h
//  ProjectB
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionReusableView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UIImageView *cover;
@property (strong, nonatomic) IBOutlet UILabel *authors;
@property (strong, nonatomic) IBOutlet UILabel *types;

@property (strong, nonatomic) IBOutlet UILabel *hot_hits;
@property (strong, nonatomic) IBOutlet UILabel *subscribe_num;

@property (strong, nonatomic) IBOutlet UIButton *kkk;

@end
