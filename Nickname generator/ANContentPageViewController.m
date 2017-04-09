//
//  ANContentPageViewController.m
//  Nickname generator
//
//  Created by Anton Novoselov on 25/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANContentPageViewController.h"
#import "ANPageViewController.h"
#import "ANAnimationHelper.h"

@interface ANContentPageViewController ()

@end

#pragma mark - CONSTANTS
extern NSString* const kAppAlreadySeen;

@implementation ANContentPageViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerLabel.text       = self.header;
    self.subHeaderLabel.text    = self.subHeader;
    self.contentImageView.image = [UIImage imageNamed:self.imageFile];
    
    self.pageControl.currentPage = self.index;
    
    self.nextButton.hidden = (self.index == 4) ? YES : NO;
    self.startButton.hidden = (self.index == 4) ? NO : YES;
    self.skipButton.hidden = !self.startButton.hidden;
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

#pragma mark - HELPER METHODS
- (void) finishPreview {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:kAppAlreadySeen];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SCENES ANIMATIONS
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
                                              
                                              [[ANAnimationHelper sharedHelper] translateView:self.clickImageView toPoint:CGPointMake(0, 0) completion:^(BOOL finished) {
                                                  
                                                  [[ANAnimationHelper sharedHelper] animateBlinkButton:self.generateButton withDelay:0.f];
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
                        [[ANAnimationHelper sharedHelper] animateShakeForView:self.shakeImageView];
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
                        
                        [[ANAnimationHelper sharedHelper] translateView:self.clickImageView toPoint:CGPointMake(0, diff) completion:^(BOOL finished) {
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
                        
                        [[ANAnimationHelper sharedHelper] translateView:self.dragImageView toPoint:CGPointMake(0, 0) completion:^(BOOL finished) {
                            [self animateViewWithControls];
                        }];
                        
                    }];
}

- (void) scene05 {
    [[ANAnimationHelper sharedHelper] animateBlinkButton:self.startButton withDelay:0.4f];
}

#pragma mark - GENERAL ANIMATIONS

- (void) animateViewWithControls {
    [UIView animateWithDuration:1.5f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.settingsViewLeadingConstraint.constant = -10;
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

- (void) animateNextSlideButton {
    [UIView animateWithDuration:0.3f
                          delay:0.6f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.nextButton.transform = CGAffineTransformMakeTranslation(0, 0);
                         
                     } completion:nil];
}

#pragma mark - ACTIONS
- (IBAction)actionNextScreen:(UIButton *)sender {
    ANPageViewController* pageVC = (ANPageViewController*) self.parentViewController;
    [pageVC nextPage:self.index];
}

- (IBAction)actionClose:(UIButton *)sender {
    [self finishPreview];
}

- (IBAction)actionSkipPressed:(id)sender {
    [self finishPreview];
}



@end
