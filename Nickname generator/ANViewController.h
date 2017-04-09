//
//  ANViewController.h
//  Nickname generator
//
//  Created by Anton Novoselov on 12/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANViewController : UIViewController

#pragma mark - OUTLETS
@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (weak, nonatomic) IBOutlet UIView *wheelView;

@property (weak, nonatomic) IBOutlet UIStackView *controlsStackView;
@property (weak, nonatomic) IBOutlet UIStackView *raceSelectionStackView;

@property (weak, nonatomic) IBOutlet UIStackView *categoryRaceLabelsStackView;
@property (weak, nonatomic) IBOutlet UIStackView *categoryRaceButtonsStackView;

@property (weak, nonatomic) IBOutlet UIPickerView *raceSelectionPickerView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *wheelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;


@property (weak, nonatomic) IBOutlet UILabel *nameCategoryLabel;
@property (weak, nonatomic) IBOutlet UIButton* nameCategorySelectButton;
@property (weak, nonatomic) IBOutlet UIButton* nameRaceSelectButton;

@property (weak, nonatomic) IBOutlet UILabel* nameResultLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;


@property (weak, nonatomic) IBOutlet UIButton* generateButton;
@property (weak, nonatomic) IBOutlet UIButton* likeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *genderButtonMasc;
@property (weak, nonatomic) IBOutlet UIButton *genderButtonFem;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingsViewLeadingConstraint;

#pragma mark - ACTIONS
- (IBAction)actionGenerateButtonPressed:(UIButton*)sender;
- (IBAction)actionlikeButtonPressed:(UIButton*)sender;

- (IBAction)actionGndrBtnPressed:(id)sender;

- (IBAction)actionCategorySelectButtonPressed:(UIButton*)sender;

- (IBAction)actionRaceSelectButtonPressed:(UIButton*)sender;


@end
