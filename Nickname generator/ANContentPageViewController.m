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



- (IBAction)actionClose:(UIButton *)sender {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:YES forKey:@"appAlreadySeen"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (IBAction)actionNextScreen:(UIButton *)sender {
    
    ANPageViewController* pageVC = (ANPageViewController*) self.parentViewController;
    
    [pageVC nextPage:self.index];
    
}





@end
