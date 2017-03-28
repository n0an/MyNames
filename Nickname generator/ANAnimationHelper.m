//
//  ANAnimationHelper.m
//  Nickname generator
//
//  Created by Anton Novoselov on 28/03/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

#import "ANAnimationHelper.h"

@implementation ANAnimationHelper

+ (ANAnimationHelper *) sharedHelper {
    
    static ANAnimationHelper *helper = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ANAnimationHelper alloc] init];
    });
    
    return helper;
}

- (void) translateView:(UIView*) view toPoint:(CGPoint) dstPoint completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:1.f
                     animations:^{
                         view.transform = CGAffineTransformMakeTranslation(dstPoint.x, dstPoint.y);
                     } completion: completion];
}

- (void) animateBlinkButton:(UIButton*) button withDelay:(CGFloat) delay {
    [UIView animateWithDuration:0.15f
                          delay:delay
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         button.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.15f animations:^{
                             button.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         }];
                     }];
}

- (void) animateShakeForView:(UIView *) view {
    [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            view.transform = CGAffineTransformMakeTranslation(-100, 0);
            [view.superview layoutIfNeeded];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.25 animations:^{
            view.transform = CGAffineTransformMakeTranslation(100, 0);
            [view.superview layoutIfNeeded];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.125 animations:^{view.transform = CGAffineTransformMakeTranslation(-50, 0);
            [view.superview layoutIfNeeded];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.875 relativeDuration:0.0625 animations:^{
            view.transform = CGAffineTransformMakeTranslation(50, 0);
            [view.superview layoutIfNeeded];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.9375 relativeDuration:0.0625 animations:^{
            view.transform = CGAffineTransformMakeTranslation(0, 0);
            [view.superview layoutIfNeeded];
        }];
    } completion:nil];
}


@end
