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

#import "ANWebViewVC.h"

@interface ANDescriptioinVC ()

@property (strong, nonatomic) ANName* currentName;

@end

@implementation ANDescriptioinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view layoutIfNeeded];
    
    self.currentName = [self.namesArray firstObject];
    
    self.descriptionLabel.text = self.currentName.nameDescription;
    
    if (self.currentName.nameURL && ![self.currentName.nameURL isEqualToString:@""]) {
        self.readMoreButton.hidden = NO;
    } else {
        self.readMoreButton.hidden = YES;
    }
    
    
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
    
    
    UISwipeGestureRecognizer* rightSwipeGesture =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer* leftSwipeGesture =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:rightSwipeGesture];
    [self.view addGestureRecognizer:leftSwipeGesture];

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
    
    if (self.currentName.nameURL && ![self.currentName.nameURL isEqualToString:@""]) {
        self.readMoreButton.hidden = NO;
    } else {
        self.readMoreButton.hidden = YES;
    }
    
}


- (void) handleImage {
    
    UIImage* currentImage = [UIImage imageNamed:self.currentName.nameImageName];
    ANLog(@"currentImage.size.width = %f",currentImage.size.width);
    ANLog(@"currentImage.size.height = %f",currentImage.size.height);
    
    CGFloat currentWidth = CGRectGetWidth(self.view.bounds);
    
    CGFloat maxRequiredSizeOfImage = MIN(currentWidth, 800);
    
    CGFloat ratio = currentImage.size.width / currentImage.size.height;
    
    CGFloat heightOfCurrentPhoto;
    CGFloat widthOfCurrentPhoto;
    
    if (ratio < 1) { // ** Portrait oriented photo
        
        heightOfCurrentPhoto = maxRequiredSizeOfImage;
        
        widthOfCurrentPhoto = heightOfCurrentPhoto * ratio;
        
    } else { // ** Landscape oriented photo
        
        widthOfCurrentPhoto = maxRequiredSizeOfImage;
        
        heightOfCurrentPhoto = widthOfCurrentPhoto / ratio;
    }

  
    ANLog(@"ratio = %f",ratio);
    ANLog(@"widthOfCurrentPhoto = %f",widthOfCurrentPhoto);
    ANLog(@"heightOfCurrentPhoto = %f",heightOfCurrentPhoto);

    
    
}




- (void) setImageAndImageHeight {
    
//    [self handleImage];
    
    UIImage* imageName = [UIImage imageNamed:self.currentName.nameImageName];
    
    if (!imageName) {
        
        self.nameImageView.image = nil;
        
        
        
        if (isOrientationPortrait()) {
            self.imageHeightConstraint.active = NO;
        }
        
        if (isOrientationLandscape()) {
            self.imageWidthLandscape.active = NO;

        }

        
        
        [self.view layoutIfNeeded];
        
        ANLog(@"no image");
        ANLog(@"self.imageHeightConstraint = %f", self.imageHeightConstraint.constant);
        
    } else {

        self.nameImageView.image = imageName;
        

        if (isOrientationPortrait()) {
            self.imageHeightConstraint.active = YES;
        }
        
        if (isOrientationLandscape()) {
            self.imageWidthLandscape.active = YES;
            
        }
        


        
        [self.view layoutIfNeeded];
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


- (void) handleRightSwipe: (UITapGestureRecognizer*) recognizer {
    
    [self iterateNameWithDirection:ANNameIterationDirectionPrevious];
    
}

- (void) handleLeftSwipe: (UITapGestureRecognizer*) recognizer {
    
    [self iterateNameWithDirection:ANNameIterationDirectionNext];
    
}




- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showANWebViewVC"]) {
        
        ANWebViewVC* vc = segue.destinationViewController;
        vc.nameURL = self.currentName.nameURL;
    }
}






@end









