//
//  ANViewController.m
//  Nickname generator
//
//  Created by Anton Novoselov on 12/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANViewController.h"
#import "ANUtils.h"
#import "ANGreekMythNames.h"

#import "ANHinduismNames.h"


@interface ANViewController ()

@property (assign, nonatomic) NSInteger namesCount;
@property (assign, nonatomic) ANGender* selectedGender;


@end

@implementation ANViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.namesCount = self.nameCountControl.selectedSegmentIndex + 1;
    self.selectedGender = (ANGender*)self.genderControl.selectedSegmentIndex;
    
    NSString* currentNamesLabel = [self getNamesStringForNamesCount:self.namesCount];
    
    self.nameResultLabel.text = currentNamesLabel;
    
    
}


#pragma mark - Helper Methods

- (NSString*) getNamesStringForNamesCount:(NSInteger) count {
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (int i = 0; i < count; i++) {
      
        ANHinduismNames* generatedName = [ANHinduismNames randomNameforGender:self.selectedGender];
        [array addObject:generatedName.firstName];
        
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
    
    self.selectedGender = (ANGender*)self.genderControl.selectedSegmentIndex;


    
    
}





@end
