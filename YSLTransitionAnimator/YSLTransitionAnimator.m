//
//  YSLTransitionAnimator.m
//  CustomTransition_Sample
//
//  Created by yamaguchi on 2015/04/16.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "YSLTransitionAnimator.h"

@implementation YSLTransitionAnimator

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.animationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // get controller
    UIViewController<YSLTransitionAnimatorDataSource> *fromViewController =
    (UIViewController<YSLTransitionAnimatorDataSource> *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController<YSLTransitionAnimatorDataSource> *toViewController =
    (UIViewController<YSLTransitionAnimatorDataSource> *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // fromViewController Setting
    UIImageView *fromTransitionImage = _isForward ? [fromViewController pushTransitionImageView] : [fromViewController popTransitionImageView];
    // UIView *imageSnapshot = [fromTransitionImage snapshotViewAfterScreenUpdates:NO];
    UIImageView *imageSnapshot = [[UIImageView alloc]initWithImage:fromTransitionImage.image];
    imageSnapshot.layer.cornerRadius = fromTransitionImage.layer.cornerRadius;
    
    imageSnapshot.frame = [containerView convertRect:fromTransitionImage.frame fromView:fromTransitionImage.superview];
    fromTransitionImage.hidden = YES;
    
    // toViewController Setting
    UIImageView *toTransitionImage = _isForward ? [toViewController popTransitionImageView] : [toViewController pushTransitionImageView];
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    
    if (_isForward) {
        // push Animation
        toViewController.view.alpha = 0;
        [containerView addSubview:toViewController.view];
        toTransitionImage.hidden = YES;
        toTransitionImage.image = fromTransitionImage.image;
        [containerView addSubview:imageSnapshot];
        
        [UIView animateWithDuration:duration animations:^{
            toViewController.view.alpha = 1.0;
            CGRect frame = [containerView convertRect:toTransitionImage.frame fromView:toViewController.view];
            frame.origin.y = _toViewControllerImagePointY;
            imageSnapshot.frame = frame;
            
            imageSnapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                imageSnapshot.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                
                [imageSnapshot removeFromSuperview];
                fromTransitionImage.hidden = NO;
                toTransitionImage.hidden = NO;
                // transition end
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];

        }];
    } else {
        // pop Animation
        toTransitionImage.hidden = YES;
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        [containerView addSubview:imageSnapshot];
        [UIView animateWithDuration:duration animations:^{
            fromViewController.view.alpha = 0.0;
            imageSnapshot.frame = [containerView convertRect:toTransitionImage.frame fromView:toTransitionImage.superview];
        } completion:^(BOOL finished) {
            
            [imageSnapshot removeFromSuperview];
            fromTransitionImage.hidden = NO;
            toTransitionImage.hidden = NO;
            // transition end
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
}


@end
