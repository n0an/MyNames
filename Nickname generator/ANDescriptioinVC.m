//
//  ANDescriptioinVC.m
//  Nickname generator
//
//  Created by Anton Novoselov on 26/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANDataManager.h"

#import "ANDescriptioinVC.h"
#import "ANName.h"
#import "ANUtils.h"

#import "ANWebViewVC.h"

#import "ANNameCategory.h"


@interface ANDescriptioinVC ()

@property (strong, nonatomic) ANName* currentName;

@property (assign, nonatomic) BOOL isNameFavorite;
@property (strong, nonatomic) UIImage* likeNonSetImage;
@property (strong, nonatomic) UIImage* likeSetImage;


@end

@implementation ANDescriptioinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view layoutIfNeeded];
    
    self.currentName = [self.namesArray firstObject];
    
    [self refreshLabels];
    
    if (self.currentName.nameURL && ![self.currentName.nameURL isEqualToString:@""]) {
        self.readMoreButton.hidden = NO;
    } else {
        self.readMoreButton.hidden = YES;
    }
    
    [self setImageAndImageHeight];
    
    
    // Navigation bar buttons
        
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close32"] landscapeImagePhone:[UIImage imageNamed:@"close24"] style:UIBarButtonItemStylePlain target:self action:@selector(actionCancel:)];
    
    self.navigationItem.leftBarButtonItem = cancel;
    
    if ([self.namesArray count] > 1) {
        
        UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowDescRight32"] landscapeImagePhone:[UIImage imageNamed:@"arrowDescRight24"] style:UIBarButtonItemStylePlain target:self action:@selector(actionNextPressed:)];
        
        UIBarButtonItem* previousButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowDescLeft32"] landscapeImagePhone:[UIImage imageNamed:@"arrowDescLeft24"] style:UIBarButtonItemStylePlain target:self action:@selector(actionPreviousPressed:)];

        UIBarButtonItem* fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        fixedSpace.width = 4;
        
        self.navigationItem.rightBarButtonItems = @[nextButton, fixedSpace, previousButton];
    }
    
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
    
    self.likeNonSetImage = [UIImage imageNamed:@"like1"];
    self.likeSetImage = [UIImage imageNamed:@"like1set"];
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setScrollViewContentSize];
    
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.isNameFavorite = [[ANDataManager sharedManager] isNameFavorite:self.currentName];
    
    [self refreshLikeButton];
    
}



#pragma mark - Helper Methods

- (void) refreshLabels {
    
    self.firstNameLabel.text = self.currentName.firstName;
    self.nameCategoryLabel.text = self.currentName.nameCategory.nameCategoryTitle;
    self.descriptionLabel.text = self.currentName.nameDescription;
    NSString* genderImage = !self.currentName.nameGender ? @"masc02" : @"fem02";
    
    self.genderImageView.image = [UIImage imageNamed:genderImage];
    
    [self.firstNameLabel sizeToFit];
    [self.nameCategoryLabel sizeToFit];
    [self.descriptionLabel sizeToFit];
}

- (void) setScrollViewContentSize {
    CGRect contentRect = CGRectZero;
    
    for (UIView *view in self.contenView.subviews) {
        NSLog(@"view size = {%f, %f}", view.bounds.size.width, view.bounds.size.height);
        contentRect = CGRectUnion(contentRect, view.frame);
        
    }
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(contentRect));
    
}


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
    
    
    
    [self refreshLabels];
    
    [self setImageAndImageHeight];
    
    if (self.currentName.nameURL && ![self.currentName.nameURL isEqualToString:@""]) {
        self.readMoreButton.hidden = NO;
    } else {
        self.readMoreButton.hidden = YES;
    }
    
    self.isNameFavorite = [[ANDataManager sharedManager] isNameFavorite:self.currentName];
    
    NSLog(@"self.isNameFavorite = %d", self.isNameFavorite);
    
    [self refreshLikeButton];
    
    
    [self setScrollViewContentSize];

    
}



- (void) setImageAndImageHeight {
    
    UIImage* imageName = [UIImage imageNamed:self.currentName.nameImageName];
    
    if (!imageName) {
        
        self.nameImageView.image = [UIImage imageNamed:@"dump"];
        
    } else {

        self.nameImageView.image = imageName;

    }

}


- (void) refreshLikeButton {
    
    NSLog(@"firstName = %d", self.isNameFavorite);
    
    if (self.isNameFavorite) {
        
        [self.likeButton setImage:self.likeSetImage forState:UIControlStateNormal];
        
    } else {
        
        [self.likeButton setImage:self.likeNonSetImage forState:UIControlStateNormal];
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

- (IBAction)actionlikeButtonPressed:(UIButton*)sender {
    // *** Saving choosen names to CoreData
    
    if (self.isNameFavorite) {
        
        [[ANDataManager sharedManager] deleteFavoriteName:self.currentName];
        
        ANLog(@"\n=========== LIKE PRESSED . FAVORITE DELETED ===========");
        [[ANDataManager sharedManager] showAllNames];
        
    } else {
        
        [[ANDataManager sharedManager] addFavoriteName:self.currentName];
        
        ANLog(@"\n=========== LIKE PRESSED . FAVORITE ADDED ===========");
        [[ANDataManager sharedManager] showAllNames];
        
    }
    
    self.isNameFavorite = !self.isNameFavorite;

    [self refreshLikeButton];
}




- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showANWebViewVC"]) {
        
        ANWebViewVC* vc = segue.destinationViewController;
        vc.nameURL = self.currentName.nameURL;
    }
}








@end









