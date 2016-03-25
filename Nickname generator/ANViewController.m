//
//  ANViewController.m
//  Nickname generator
//
//  Created by Anton Novoselov on 12/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANViewController.h"
#import "ANUtils.h"

#import "ANCategoryVC.h"

#import "ANNamesFactory.h"


@interface ANViewController () <UITextFieldDelegate, ANCategorySelectionDelegate>

@property (assign, nonatomic) NSInteger namesCount;
@property (assign, nonatomic) ANGender selectedGender;

@property (strong, nonatomic) NSArray* namesCategories;

@property (assign, nonatomic) ANNamesCategory selectedCategoryInd;

@property (strong, nonatomic) ANNamesFactory* sharedNamesFactory;

@end

@implementation ANViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedNamesFactory = [ANNamesFactory sharedFactory];
    
//    self.namesCategories = [NSArray arrayWithObjects:
//                            @"Greek Mythology",
//                            @"Hinduism",
//                            nil];
    
    
    self.selectedCategoryInd = ANNamesCategoryGreekMythology;
    
//    self.nameCategoryTextField.text = [self.namesCategories objectAtIndex:self.selectedCategoryInd];
    self.nameCategoryTextField.text = [self.sharedNamesFactory.namesCategories objectAtIndex:self.selectedCategoryInd];
    
    self.namesCount = self.nameCountControl.selectedSegmentIndex + 1;
    
    self.selectedGender = (ANGender)self.genderControl.selectedSegmentIndex;
    
    NSString* currentNamesLabel = [self getNamesStringForNamesCount:self.namesCount];
    
    self.nameResultLabel.text = currentNamesLabel;
    
    
}


#pragma mark - Helper Methods


- (NSString*) getNamesStringForNamesCount:(NSInteger) count {
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (int nameIndex = 0; nameIndex < count; nameIndex++) {
        
        NSString* name = [[ANNamesFactory sharedFactory] getRandomNameForCategory:self.selectedCategoryInd andGender:self.selectedGender];
        
        [array addObject:name];
    }
    
    NSString* resultString = [array componentsJoinedByString:@" "];
    
    return resultString;
}



#pragma mark - Actions

- (IBAction)actionGenerateButtonPressed:(UIButton*)sender {
    
    NSString* currentNamesLabel = [self getNamesStringForNamesCount:self.namesCount];
    
    self.nameResultLabel.text = currentNamesLabel;
    
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
    
//    vc.categories = self.namesCategories;
    vc.categories = self.sharedNamesFactory.namesCategories;
    vc.selectedCategoryIndex = self.selectedCategoryInd;
    
    vc.delegate = self;
    
    ANLog(@"selectedCategoryIndex = %d", vc.selectedCategoryIndex);

    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}


#pragma mark - +++ ANCategorySelectionDelegate +++

- (void) categoryDidSelect:(NSInteger) categoryIndex {
    
    self.selectedCategoryInd = (ANNamesCategory)categoryIndex;
    
//    self.nameCategoryTextField.text = [self.namesCategories objectAtIndex:self.selectedCategoryInd];
    self.nameCategoryTextField.text = [self.sharedNamesFactory.namesCategories objectAtIndex:self.selectedCategoryInd];


}








@end














