//
//  ReadModel.m
//  ProjectB
//
//  Created by lanou on 16/7/30.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "ReadModel.h"

@implementation ReadModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{}
- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"])
    {
        self.bookID = [NSString stringWithFormat:@"id"];
    }
}


@end
