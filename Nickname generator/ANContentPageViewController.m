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
    
    
    if (self.index == 0) {
        
        [self sceneOne];
        
    }
    
    
    
    
}


- (void) sceneOne {
    
    self.likeButton.hidden = NO;
    self.generateButton.hidden = NO;
    
    self.clickImageView.hidden = NO;
    
    self.firstDimView.backgroundColor = [UIColor whiteColor];
    self.firstDimView.alpha = 0.f;
    
    self.clickImageView.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    
    
    [UIView animateWithDuration:0.f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.firstDimView.alpha = 0.1f;
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:1.4f
                                               delay:1.f
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              
                                              self.firstDimView.alpha = 0.8f;
                                          } completion:^(BOOL finished) {
                                              [self animateClickImageView];
                                          }];
                         
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
