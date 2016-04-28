//
//  ANContentPageViewController.m
//  Nickname generator
//
//  Created by Anton Novoselov on 25/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANContentPageViewController.h"
#import "ANPageViewController.h"

@interface ANContentPageViewController ()

@end

extern NSString* const kAppAlreadySeen;

@implementation ANContentPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerLabel.text = self.header;
    self.subHeaderLabel.text = self.subHeader;
    self.contentImageView.image = [UIImage imageNamed:self.imageFile];
    
    
    self.pageControl.currentPage = self.index;
    
    self.nextButton.hidden = (self.index == 4) ? YES : NO;
    
    self.startButton.hidden = (self.index == 4) ? NO : YES;
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    switch (self.index) {
        case 0:
            [self sceneOne];
            break;
            
        case 1:
            [self sceneTwo];
            break;
            
        case 2:
            [self sceneThree];
            break;
            
        default:
            break;
    }
    
    
    
    
}


- (void) sceneOne {
    
    self.likeButton.hidden = NO;
    self.generateButton.hidden = NO;
    
    self.clickImageView.hidden = NO;
    
    self.firstDimView.hidden = NO;
    self.firstDimView.backgroundColor = [UIColor whiteColor];
    self.firstDimView.alpha = 0;
    
    self.clickImageView.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    
    [UIView animateWithDuration:0.f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.firstDimView.alpha = 0.1f;
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:1.0f
                                               delay:1.f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              
                                              self.firstDimView.alpha = 0.8f;
                                          } completion:^(BOOL finished) {
                                              [self animateClickImageViewTranslateToPoint:CGPointMake(0, 0)];
                                          }];
                         
                     }];
    

}


- (void) sceneTwo {
    
    self.shakeImageView.hidden = NO;
    
    self.secondDimView.hidden = NO;
    self.secondDimView.backgroundColor = [UIColor whiteColor];
    self.secondDimView.alpha = 0;
    
    
    [UIView transitionWithView:self.secondDimView
                      duration:1.0f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                        self.secondDimView.alpha = 0.9f;
                    } completion:^(BOOL finished) {
                        [self animateShake];
                    }];
    
    
    
    
}

- (void) sceneThree {
    
    self.likeButton.hidden = NO;
    self.generateButton.hidden = NO;
    
    self.clickImageView.hidden = NO;
    
    self.secondDimView.hidden = NO;
    self.secondDimView.backgroundColor = [UIColor whiteColor];
    self.secondDimView.alpha = 0;
    
    self.clickImageView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.view.bounds));
    
    [self.view bringSubviewToFront:self.likeButton];
    
    [UIView transitionWithView:self.secondDimView
                      duration:1.0f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                        self.secondDimView.alpha = 0.9f;
                    } completion:^(BOOL finished) {
                        
                        CGFloat diff = self.likeButton.center.y - self.generateButton.center.y;
                        
                        [self animateClickImageViewTranslateToPoint:CGPointMake(0, diff)];

                        
                        
                    }];
    
    

    
    
    
}



#pragma mark - Helper methods

- (void) animateClickImageView {
    
    [UIView animateWithDuration:1.f
                     animations:^{
                         self.clickImageView.transform = CGAffineTransformIdentity;

                     } completion:^(BOOL finished) {
                         
                     }];
    
}

- (void) animateClickImageViewTranslateToPoint:(CGPoint) dstPoint {
    
    [UIView animateWithDuration:1.f
                     animations:^{
                         self.clickImageView.transform = CGAffineTransformMakeTranslation(dstPoint.x, dstPoint.y);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
}


- (void) animateShake {
    
    [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            self.shakeImageView.transform = CGAffineTransformMakeTranslation(-100, 0);
            [self.view layoutIfNeeded];
            
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.25 animations:^{
            self.shakeImageView.transform = CGAffineTransformMakeTranslation(100, 0);
            [self.view layoutIfNeeded];

        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.125 animations:^{
            self.shakeImageView.transform = CGAffineTransformMakeTranslation(-50, 0);
            [self.view layoutIfNeeded];

        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.875 relativeDuration:0.0625 animations:^{
            self.shakeImageView.transform = CGAffineTransformMakeTranslation(50, 0);
            [self.view layoutIfNeeded];

        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.9375 relativeDuration:0.0625 animations:^{
            self.shakeImageView.transform = CGAffineTransformMakeTranslation(0, 0);
            [self.view layoutIfNeeded];

        }];
        
    } completion:nil];
    
    
}



- (IBAction)actionClose:(UIButton *)sender {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:YES forKey:kAppAlreadySeen];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (IBAction)actionNextScreen:(UIButton *)sender {
    
    ANPageViewController* pageVC = (ANPageViewController*) self.parentViewController;
    
    [pageVC nextPage:self.index];
    
}





@end
