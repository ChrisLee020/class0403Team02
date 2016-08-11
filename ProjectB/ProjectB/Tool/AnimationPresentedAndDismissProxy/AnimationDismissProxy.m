//
//  AnimationDismissProxy.m
//  ProjectB
//
//  Created by Chris on 16/8/10.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "AnimationDismissProxy.h"

@implementation AnimationDismissProxy

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toVC.view.hidden = NO;
    
//    fromView.backgroundColor = [UIColor clearColor];
   
    [UIView animateWithDuration:0.5 animations:^{
        
        
        if (fromView.transform.b > 0) {
            
            fromView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
        else
        {
            fromView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
        
    }];
    
}

@end
