//
//  ANDescriptioinVC.m
//  Nickname generator
//
//  Created by Anton Novoselov on 26/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANDescriptioinVC.h"
#import "ANName.h"
#import "ANUtils.h"

@interface ANDescriptioinVC ()

@property (strong, nonatomic) ANName* currentName;

@end

@implementation ANDescriptioinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentName = [self.namesArray firstObject];
    
    self.descriptionLabel.text = self.currentName.nameDescription;
    
    
    [self setImageAndImageHeight];
    
    
    // Navigation bar buttons
    
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel:)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStylePlain target:self action:@selector(actionNextPressed:)];
    UIBarButtonItem* previousButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(actionPreviousPressed:)];
    
    UIBarButtonItem* fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpace.width = 50;
    
    self.navigationItem.rightBarButtonItems = @[nextButton, fixedSpace, previousButton];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
//    
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
}


#pragma mark - Helper Methods

- (void) iterateNameWithDirection:(ANNameIterationDirection) iterationDirection {
    
    NSInteger currInd = [self.namesArray indexOfObject:self.currentName];
    
    if (iterationDirection == ANNameIterationDirectionNext) {
        if ([self.currentName isEqual:[self.namesArray lastObject]]) {
            self.currentName = [self.namesArray firstObject];
            
        } else {
            self.currentName = [self.namesArray objectAtIndex:currInd + 1];
            
        }
        
    } else {
        if ([self.currentName isEqual:[self.namesArray firstObject]]) {
            self.currentName = [self.namesArray lastObject];
        } else {
            self.currentName = [self.namesArray objectAtIndex:currInd - 1];
        }
    }
    
    self.descriptionLabel.text = self.currentName.nameDescription;
    
    [self setImageAndImageHeight];
    
}



- (void) setImageAndImageHeight {
    UIImage* imageName = [UIImage imageNamed:self.currentName.nameImageName];
    
    if (!imageName) {
        self.imageHeightConstraint.constant = 0;
        
        ANLog(@"no image");
        ANLog(@"self.imageHeightConstraint = %f", self.imageHeightConstraint.constant);
        
    } else {
        self.nameImageView.image = imageName;
        ANLog(@"there's image");
        ANLog(@"self.imageHeightConstraint = %f", self.imageHeightConstraint.constant);
        
    }

}



#pragma mark - Actions

- (void) actionCancel:(UIBarButtonItem*) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) actionNextPressed:(UIBarButtonItem*) sender {
    
    [self iterateNameWithDirection:ANNameIterationDirectionNext];
    
}

- (void) actionPreviousPressed:(UIBarButtonItem*) sender {

    [self iterateNameWithDirection:ANNameIterationDirectionPrevious];
    
}











@end









