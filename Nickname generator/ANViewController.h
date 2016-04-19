//
//  ANViewController.h
//  Nickname generator
//
//  Created by Anton Novoselov on 12/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView* bgImageView;
@property (weak, nonatomic) IBOutlet UIView* controlsView;
@property (weak, nonatomic) IBOutlet UIView *wheelView;

@property (weak, nonatomic) IBOutlet UIImageView *wheelImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingsViewLeadingConstraint;

@property (weak, nonatomic) IBOutlet UILabel* nameResultLabel;
@property (weak, nonatomic) IBOutlet UIButton* generateButton;

@property (weak, nonatomic) IBOutlet UITextField* nameCategoryTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl* nameCountControl;

@property (weak, nonatomic) IBOutlet UIButton* likeButton;

@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;

@property (weak, nonatomic) IBOutlet UIButton *genderButtonMasc;

@property (weak, nonatomic) IBOutlet UIButton *genderButtonFem;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewGenderMasc;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewGenderFem;


- (IBAction)actionGenerateButtonPressed:(UIButton*)sender;
- (IBAction)actionlikeButtonPressed:(UIButton*)sender;


- (IBAction)actionNameCountControlValueChanged:(UISegmentedControl*)sender;


- (IBAction)actionGndrBtnPressed:(id)sender;

- (IBAction)actionWheelBtnPressed:(UIButton *)sender;



@end
