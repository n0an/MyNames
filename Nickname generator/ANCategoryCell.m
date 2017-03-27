//
//  ANCategoryCell.m
//  Nickname generator
//
//  Created by Anton Novoselov on 26/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANCategoryCell.h"

#import "ANNameCategory.h"
#import "ANUtils.h"

extern NSString* const kAppLaunchesCount;

@implementation ANCategoryCell


- (void) configureCellWithNameCategory:(ANNameCategory*) nameCategory {
    
    [self.categoryNewBadge setHidden:YES];
    
    if ([nameCategory.nameCategoryID isEqualToString:@"02.01"]) {
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSInteger appLaunchesCount = [userDefaults integerForKey:kAppLaunchesCount];
        
        ANLog(@"appLaunchesCount = %d", appLaunchesCount);
        
        if (appLaunchesCount < 10) {
            [self.categoryNewBadge setHidden:NO];
        } else {
            [self.categoryNewBadge setHidden:YES];
        }
    }
    
    
}


#pragma mark - ANIMATIONS
- (void) animateDeselection {
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.categoryName.alpha = 0;
                         self.fadeView.alpha = 0.5;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:0.2f
                          delay:0.1f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         CGFloat cellWidth = CGRectGetWidth(self.frame);
                         self.whiteBoxLeftConstraint.constant = cellWidth * 2;
                         
                         [self layoutIfNeeded];
                     } completion:nil];
    
}

- (void) animateSelection {
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.categoryName.alpha = 1;
                         self.fadeView.alpha = 0;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:0.2f
                          delay:0.1f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.whiteBoxLeftConstraint.constant = 0;
                         [self layoutIfNeeded];
                     } completion:nil];
    
}


@end
