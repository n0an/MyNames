//
//  ANViewController.h
//  Nickname generator
//
//  Created by Anton Novoselov on 12/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel* nameResultLabel;
@property (weak, nonatomic) IBOutlet UIButton* generateButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl* genderControl;
@property (weak, nonatomic) IBOutlet UITextField* nameCategoryTextField;
@property (weak, nonatomic) IBOutlet UITextField* nameCountTextField;



- (IBAction)actionGenerateButtonPressed:(UIButton*)sender;
- (IBAction)actionGenderControlValueChanged:(UISegmentedControl*)sender;



@end
