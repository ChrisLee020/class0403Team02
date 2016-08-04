//
//  ReadCollectionViewCell.h
//  ProjectB
//
//  Created by lanou on 16/7/30.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UILabel *subtitle;
@property (strong, nonatomic) IBOutlet UILabel *title;

@end
