//
//  RadioListCell.h
//  ProjectB
//
//  Created by Chris on 16/7/30.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioListCell : UICollectionViewCell

//封面
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;

//标题
@property (strong, nonatomic) IBOutlet UILabel *title;

//作者
@property (strong, nonatomic) IBOutlet UILabel *subTitle;


@end
