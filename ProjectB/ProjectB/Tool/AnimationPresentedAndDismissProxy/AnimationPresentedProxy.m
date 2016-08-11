//
//  AnimationPresentedProxy.m
//  ProjectB
//
//  Created by Chris on 16/8/10.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "AnimationPresentedProxy.h"

@implementation AnimationPresentedProxy

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
//    屏幕截屏
    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    
    tempView.frame = fromVC.view.frame;
    
    fromVC.view.hidden = YES;
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:tempView];
    
    [containerView addSubview:toVC.view];
    
    toVC.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    [UIView animateWithDuration:0.5 animations:^{
        
        toVC.view.transform = CGAffineTransformIdentity;
        
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
        
    }];
    
}

@end
