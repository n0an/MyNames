//
//  ANContentPageViewController.h
//  Nickname generator
//
//  Created by Anton Novoselov on 25/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANContentPageViewController : UIViewController

#pragma mark - OUTLETS
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *subHeaderLabel;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *generateButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property (weak, nonatomic) IBOutlet UIView *firstDimView;
@property (weak, nonatomic) IBOutlet UIView *secondDimView;
@property (weak, nonatomic) IBOutlet UIView *viewWithControls;

@property (weak, nonatomic) IBOutlet UIImageView *clickImageView;
@property (weak, nonatomic) IBOutlet UIImageView *dragImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shakeImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingsViewLeadingConstraint;

#pragma mark - ACTIONS
- (IBAction)actionClose:(UIButton *)sender;
- (IBAction)actionNextScreen:(UIButton *)sender;

#pragma mark - PUBLIC PROPERTIES
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString* header;
@property (strong, nonatomic) NSString* subHeader;
@property (strong, nonatomic) NSString* imageFile;

@end
