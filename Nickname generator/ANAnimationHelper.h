//
//  ANAnimationHelper.h
//  Nickname generator
//
//  Created by Anton Novoselov on 28/03/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANAnimationHelper : NSObject

+ (ANAnimationHelper *) sharedHelper;

- (void) animateShakeForView:(UIView *) view;
- (void) translateView:(UIView*) view toPoint:(CGPoint) dstPoint completion:(void (^)(BOOL finished))completion;
- (void) animateBlinkButton:(UIButton*) button withDelay:(CGFloat) delay;

@end
