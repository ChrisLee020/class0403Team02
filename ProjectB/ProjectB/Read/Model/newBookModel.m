//
//  newBookModel.m
//  ProjectB
//
//  Created by lanou on 16/8/3.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "newBookModel.h"

@implementation newBookModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"id"])
    {
        self.bookID = value;
    }
}
@end
