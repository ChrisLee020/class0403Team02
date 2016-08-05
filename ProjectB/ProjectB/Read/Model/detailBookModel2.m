//
//  detailBookModel2.m
//  ProjectB
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "detailBookModel2.h"

@implementation detailBookModel2
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue: value forKey:key];
    if ([key isEqualToString:@"id"])
    {
        self.bookID = [NSString stringWithFormat:@"%@", value];
    }
}

@end
