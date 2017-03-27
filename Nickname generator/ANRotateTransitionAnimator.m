//
//  ANRotateTransitionAnimator.m
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

#import "ANRotateTransitionAnimator.h"

@interface ANRotateTransitionAnimator ()

@end

CGFloat const duration = 0.5f;

@implementation ANRotateTransitionAnimator
    
#pragma mark - UIViewControllerTransitioningDelegate
    
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return self;
}
    
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return self;
}
    
#pragma mark - UIViewControllerAnimatedTransitioning
    
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return duration;
}
    
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    if ((fromView == nil) && (toView == nil)) {
        return;
    }
    
    // Set up the transform we'll use in the animation
    UIView *container = [transitionContext containerView];
    
    // Set up the transform for rotation
    // The angle is in radian. To convert from degree to radian, use this formula
    // radian = angle * pi / 180
    
    CGAffineTransform rotateOut = CGAffineTransformMakeRotation(-90 * M_PI / 180);
    
    // Change the anchor point and position
    [toView.layer setAnchorPoint:CGPointZero];
    [fromView.layer setAnchorPoint:CGPointZero];

    [toView.layer setPosition:CGPointZero];
    [fromView.layer setPosition:CGPointZero];
    
    // Change the initial position of the toView
    toView.transform = rotateOut;
    
    // Add both views to the container view.
    [container addSubview:toView];
    [container addSubview:fromView];
    
    // Perform the animation
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         fromView.transform = rotateOut;
                         fromView.alpha = 0;
                         
                         toView.transform = CGAffineTransformIdentity;
                         toView.alpha = 1.0;
                         
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
    
}


@end

