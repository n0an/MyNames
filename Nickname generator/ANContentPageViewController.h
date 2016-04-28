//
//  ANContentPageViewController.h
//  Nickname generator
//
//  Created by Anton Novoselov on 25/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANContentPageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UILabel *subHeaderLabel;

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;




@property (weak, nonatomic) IBOutlet UIView *firstDimView;
@property (weak, nonatomic) IBOutlet UIView *secondDimView;

@property (weak, nonatomic) IBOutlet UIButton *generateButton;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIImageView *clickImageView;

@property (weak, nonatomic) IBOutlet UIImageView *shakeImageView;






- (IBAction)actionClose:(UIButton *)sender;
- (IBAction)actionNextScreen:(UIButton *)sender;



@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString* header;
@property (strong, nonatomic) NSString* subHeader;
@property (strong, nonatomic) NSString* imageFile;



@end
