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
            [self scene01];
            break;
            
        case 1:
            [self scene02];
            break;
            
        case 2:
            [self scene03];
            break;
            
        case 3:
            [self scene04];
            break;
            
        case 4:
            [self scene05];
            break;
            
        default:
            break;
    }
    
    
    
    
}


- (void) scene01 {
    
    self.nextButton.transform = CGAffineTransformMakeTranslation(200, 0);
    
    

    
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
                         [self animateNextSlideButton];
                         
                         [UIView animateWithDuration:0.5f
                                               delay:0.f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              
                                              self.firstDimView.alpha = 0.8f;
                                          } completion:^(BOOL finished) {
                                              [self translateView:self.clickImageView toPoint:CGPointMake(0, 0) completion:^(BOOL finished) {
                                              
                                                  [self animateBlinkButton:self.generateButton withDelay:0.f];
                                              
                                              }];
                                          }];
                         
                     }];
    
    
}


- (void) scene02 {
    
    self.nextButton.transform = CGAffineTransformMakeTranslation(200, 0);
    
    [self animateNextSlideButton];
    
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

- (void) scene03 {
    
    self.nextButton.transform = CGAffineTransformMakeTranslation(200, 0);
    
    [self animateNextSlideButton];
    
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
                        
                        [self translateView:self.clickImageView toPoint:CGPointMake(0, diff) completion:^(BOOL finished) {
                            
                            [self.likeButton setImage:[UIImage imageNamed:@"like1set"] forState:UIControlStateNormal];
                            
                        }];


                    }];
 
}

- (void) scene04 {
    
    self.nextButton.transform = CGAffineTransformMakeTranslation(200, 0);
    
    [self animateNextSlideButton];
    
    self.viewWithControls.hidden = NO;
    self.dragImageView.hidden = NO;
    
    self.dragImageView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.viewWithControls.bounds));
    
    self.secondDimView.hidden = NO;
    self.secondDimView.backgroundColor = [UIColor whiteColor];
    self.secondDimView.alpha = 0;
    
    self.settingsViewLeadingConstraint.constant = -321;
    [self.view layoutIfNeeded];

    
    [UIView transitionWithView:self.secondDimView
                      duration:1.0f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                        self.secondDimView.alpha = 0.9f;
                    } completion:^(BOOL finished) {
                        
                        [self translateView:self.dragImageView toPoint:CGPointMake(0, 0) completion:^(BOOL finished) {
                            [self animateViewWithControls];
                        }];
                        
                        

                    }];

    
    
}

- (void) scene05 {
    
    
    [self animateBlinkButton:self.startButton withDelay:0.7f];

    
}



#pragma mark - Helper methods


- (void) translateView:(UIView*) view toPoint:(CGPoint) dstPoint completion:(void (^)(BOOL finished))completion {
    
    [UIView animateWithDuration:1.f
                     animations:^{
                         view.transform = CGAffineTransformMakeTranslation(dstPoint.x, dstPoint.y);
                         
                     } completion: completion];
    
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


- (void) animateViewWithControls {
    
    
    [UIView animateWithDuration:1.5f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.settingsViewLeadingConstraint.constant = -10;
                         [self.view layoutIfNeeded];
                     } completion:nil];
    
    
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



- (void) animateNextSlideButton {
    
    [UIView animateWithDuration:0.3f
                          delay:0.6f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.nextButton.transform = CGAffineTransformMakeTranslation(0, 0);
                         
                     } completion:^(BOOL finished) {
                         
                     }];

    
}




#pragma mark - Actions

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
