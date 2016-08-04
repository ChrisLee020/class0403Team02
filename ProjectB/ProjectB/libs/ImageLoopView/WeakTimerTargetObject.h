//
//  WeakTimerTargetObject.h
//  图片无限轮播
//
//  Created by Chris on 16/7/25.
//  Copyright © 2016年 kimlee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakTimerTargetObject : NSObject

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;


@end
