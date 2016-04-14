//
//  ANViewController.m
//  Nickname generator
//
//  Created by Anton Novoselov on 12/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANViewController.h"
#import "ANUtils.h"
#import "ANDataManager.h"

#import "ANCategoryVC.h"
#import "ANDescriptioinVC.h"

#import "ANName.h"
#import "ANNameCategory.h"
#import "ANNamesFactory.h"


@interface ANViewController () <UITextFieldDelegate, ANCategorySelectionDelegate>

@property (assign, nonatomic) NSInteger namesCount;
@property (assign, nonatomic) ANGender selectedGender;

@property (strong, nonatomic) ANNameCategory* selectedCategory;

@property (strong, nonatomic) ANNamesFactory* sharedNamesFactory;

@property (strong, nonatomic) NSArray* displayedNames;
@property (strong, nonatomic) NSArray* namesWithDescriptions;

@property (assign, nonatomic) BOOL isDescriptionAvailable;

@end

@implementation ANViewController

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedNamesFactory = [ANNamesFactory sharedFactory];
    
    // Choose MythGreek Category for default
    self.selectedCategory = [self.sharedNamesFactory.namesCategories objectAtIndex:0];
    
    self.nameCategoryTextField.text = self.selectedCategory.nameCategoryTitle;
    
    self.namesCount = self.nameCountControl.selectedSegmentIndex + 1;
    
    self.selectedGender = (ANGender)self.genderControl.selectedSegmentIndex;
    
    self.isDescriptionAvailable = NO;
    
    NSString* currentNamesLabel = [self getNamesStringForNamesCount:self.namesCount];
    
    self.nameResultLabel.text = currentNamesLabel;
    
    
    UIBlurEffect *lightBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *lightBlurEffectView = [[UIVisualEffectView alloc] initWithEffect:lightBlurEffect];
    
//    lightBlurEffectView.frame = self.view.bounds;
//    [self.bgImageView addSubview:lightBlurEffectView];
    
    [self.bgImageView setImage:[UIImage imageNamed:self.selectedCategory.nameCategoryBackgroundImageName]];
    
    
    lightBlurEffectView.frame = self.controlsView.bounds;
    [self.controlsView insertSubview:lightBlurEffectView atIndex:0];
    
    self.controlsView.clipsToBounds = YES;
    
    self.controlsView.layer.cornerRadius = 10.f;
//    lightBlurEffectView.layer.cornerRadius = 30.f;
    
    // Initial Animation State of Generate Button
    self.generateButton.transform = CGAffineTransformMakeScale(0.f, 0.f);
    
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self animateGenerateButton];
    
    // Setting gesture recognizer for main label
    
    if (self.isDescriptionAvailable) {
        self.nameResultLabel.userInteractionEnabled = YES;
    } else {
        self.nameResultLabel.userInteractionEnabled = NO;
    }
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapOnNameLabel:)];
    
    
    
    [self.nameResultLabel addGestureRecognizer:tapGesture];
    
}



#pragma mark - Animations

- (void) animateGenerateButton {
    
    [UIView animateWithDuration:0.7f
                          delay:0.f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.generateButton.transform = CGAffineTransformMakeScale(1.f, 1.f);
                         
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

- (void) animateGenerateButtonOnClick {
    
    
    
    [UIView animateWithDuration:0.15f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.generateButton.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.15f animations:^{
                             self.generateButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         }];
                         
                     }];
    
    
}



#pragma mark - Helper Methods

- (NSString*) getNamesStringForNamesCount:(NSInteger) count {
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (int nameIndex = 0; nameIndex < count; nameIndex++) {
        ANName* name = [[ANNamesFactory sharedFactory] getRandomNameForCategory:self.selectedCategory andGender:self.selectedGender];
        
        [array addObject:name];
    }
    self.displayedNames = array;
    
    NSString* resultString = @"";
    
    for (ANName* name in array) {
        resultString = [NSString stringWithFormat:@"%@ %@", resultString, name.firstName];
    }
    
    self.namesWithDescriptions = [self getNamesWithDescriptions];
    return resultString;
}


- (NSArray*) getNamesWithDescriptions {
    
    NSMutableArray* cleanArray = [NSMutableArray array];
    
    for (ANName* name in self.displayedNames) {

        if (name.nameDescription && ![name.nameDescription isEqualToString:@""]) {
            [cleanArray addObject:name];
        }
    }
    
    if ([cleanArray count] > 0) {
        self.isDescriptionAvailable = YES;
    } else {
        self.isDescriptionAvailable = NO;
    }
    
    NSArray* resArray = cleanArray;
    
    return resArray;
}



#pragma mark - Actions

- (void) actionTapOnNameLabel:(UITapGestureRecognizer*) recognizer {
    
    ANLog(@"actionTapOnNameLabel");
    
    // *** If there're names in array of names with descriptions - initializate ANDescriptionVC and transfer names array to it.
    
    if (self.isDescriptionAvailable) {
        ANDescriptioinVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ANDescriptioinVC"];
        
        vc.namesArray = self.namesWithDescriptions;
        
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:nav animated:YES completion:nil];
        

    }
    
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (UIEventSubtypeMotionShake) {
        
        ANLog(@"I'm shaking!");
        
        NSString* currentNamesLabel = [self getNamesStringForNamesCount:self.namesCount];
        
        self.nameResultLabel.text = currentNamesLabel;
    }
}


- (IBAction)actionGenerateButtonPressed:(UIButton*)sender {
    
    [self animateGenerateButtonOnClick];
    
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.nameResultLabel.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         
                         NSString* currentNamesLabel = [self getNamesStringForNamesCount:self.namesCount];
                         
                         self.nameResultLabel.text = currentNamesLabel;
                         
                         [UIView animateWithDuration:0.5f
                                          animations:^{
                                              self.nameResultLabel.alpha = 1.f;
                                          }];
                         
                     }];

    
    
}


- (IBAction)actionlikeButtonPressed:(UIButton*)sender {
    // *** Saving choosen names to CoreData
    
    NSArray* arr = self.displayedNames;
    [[ANDataManager sharedManager] addFavoriteName:[arr firstObject]];
    
    ANLog(@"\n=========== LIKE PRESSED ===========");
    [[ANDataManager sharedManager] showAllNames];
    
}


- (IBAction)actionNameCountControlValueChanged:(UISegmentedControl*)sender {
    
    ANLog(@"New value is = %d", sender.selectedSegmentIndex);
    
    self.namesCount = sender.selectedSegmentIndex + 1;
    
}



- (IBAction)actionGenderControlValueChanged:(UISegmentedControl*)sender {
    
    ANLog(@"actionGenderControlValueChanged");
    ANLog(@"New value is = %d", sender.selectedSegmentIndex);
    
    self.selectedGender = (ANGender)self.genderControl.selectedSegmentIndex;

}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    ANLog(@"textFieldDidBeginEditing");
    
    ANCategoryVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ANCategoryVC"];
    
    vc.categories = self.sharedNamesFactory.namesCategories;

    vc.selectedCategory = self.selectedCategory;
    
    vc.delegate = self;
    
    ANLog(@"selectedCategory = %@", vc.selectedCategory);

    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}


#pragma mark - +++ ANCategorySelectionDelegate +++

- (void) categoryDidSelect:(ANNameCategory*) category {
    
    self.selectedCategory = category;
    
    [self.bgImageView setImage:[UIImage imageNamed:self.selectedCategory.nameCategoryBackgroundImageName]];
    
    NSString* currentNamesLabel = [self getNamesStringForNamesCount:self.namesCount];
    
    self.nameResultLabel.text = currentNamesLabel;
    

    self.nameCategoryTextField.text = self.selectedCategory.nameCategoryTitle;

}





@end














