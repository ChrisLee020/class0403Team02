//
//  WeakTimerTargetObject.m
//  图片无限轮播
//
//  Created by Chris on 16/7/25.
//  Copyright © 2016年 kimlee. All rights reserved.
//

#import "WeakTimerTargetObject.h"

@interface WeakTimerTargetObject ()

@property (nonatomic, weak) id target;
@property (nonatomic, assign)SEL selector;


@end

@implementation WeakTimerTargetObject

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo
{
//    创建当前类的对象
    WeakTimerTargetObject *object = [[WeakTimerTargetObject alloc] init];
    
    object.target = aTarget;
    
    object.selector = aSelector;
    
    return [NSTimer scheduledTimerWithTimeInterval:ti target:object selector:@selector(fire:) userInfo:userInfo repeats:yesOrNo];
}

- (void)fire:(id)obj
{
    [self.target performSelector:self.selector withObject:obj];
}

@end
