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
#import "ANNameCategory.h"
#import <SafariServices/SafariServices.h>
#import "UIViewController+ANAlerts.h"
#import <Firebase.h>
#import <FirebaseStorage/FirebaseStorage.h>
#import "ANFBStorageManager.h"

@interface ANDescriptioinVC ()

#pragma mark - PRIVATE PROPERTIES
@property (strong, nonatomic) ANName* currentName;
@property (assign, nonatomic) BOOL isNameFavorite;
@property (strong, nonatomic) UIImage* likeNonSetImage;
@property (strong, nonatomic) UIImage* likeSetImage;
@property (strong, nonatomic) UIBarButtonItem* shareButton;

@end

@implementation ANDescriptioinVC

#pragma mark - viewDidLoad
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
    
//    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close32"] landscapeImagePhone:[UIImage imageNamed:@"close24"] style:UIBarButtonItemStylePlain target:self action:@selector(actionCancel:)];
    
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close24"] style:UIBarButtonItemStylePlain target:self action:@selector(actionCancel:)];
    
    self.navigationItem.leftBarButtonItem = cancel;
    
    NSMutableArray* rightBarButtonItems = [NSMutableArray array];
    
    UIBarButtonItem* shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionShareButtonPressed:)];
    self.shareButton = shareButton;
    [rightBarButtonItems addObject:shareButton];
    
    if ([self.namesArray count] > 1) {
        UIBarButtonItem* fixedSpaceFirst = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        fixedSpaceFirst.width = 10;
        
//        UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowDescRight32"] landscapeImagePhone:[UIImage imageNamed:@"arrowDescRight24"] style:UIBarButtonItemStylePlain target:self action:@selector(actionNextPressed:)];
        
//        UIBarButtonItem* previousButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowDescLeft32"] landscapeImagePhone:[UIImage imageNamed:@"arrowDescLeft24"] style:UIBarButtonItemStylePlain target:self action:@selector(actionPreviousPressed:)];
        
        
        UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowRight03"] style:UIBarButtonItemStylePlain target:self action:@selector(actionNextPressed:)];

        
        
        UIBarButtonItem* previousButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowLeft03"] style:UIBarButtonItemStylePlain target:self action:@selector(actionPreviousPressed:)];
        
        
        
        
        

        UIBarButtonItem* fixedSpaceBetween = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        fixedSpaceBetween.width = 4;
        
        [rightBarButtonItems addObjectsFromArray:@[fixedSpaceFirst, nextButton, fixedSpaceBetween, previousButton]];
    }
    
    self.navigationItem.rightBarButtonItems = rightBarButtonItems;
    
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
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isNameFavorite = [[ANDataManager sharedManager] isNameFavorite:self.currentName];
    [self refreshLikeButton];
}

#pragma mark - HELPER METHODS
- (void) refreshLabels {
    self.firstNameLabel.text = self.currentName.firstName;
    self.nameCategoryLabel.text = self.currentName.nameCategory.nameCategoryTitle;

    self.descriptionTextView.text = self.currentName.nameDescription;
    NSString* genderImage = !self.currentName.nameGender ? @"masc02" : @"fem02";
    
    self.genderImageView.image = [UIImage imageNamed:genderImage];
    
    [self.firstNameLabel sizeToFit];
    [self.nameCategoryLabel sizeToFit];
    
    self.navigationItem.title = self.currentName.firstName;
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
    
    [self refreshLikeButton];
}

- (void) setImageAndImageHeight {

    NSString *categoryAlias = self.currentName.nameCategory.alias;
    
    NSString* pathName;
    
    if (self.currentName.nameGender == ANGenderMasculine) {
        pathName = [categoryAlias stringByAppendingString:@"MascImages"];
    } else {
        pathName = [categoryAlias stringByAppendingString:@"FemImages"];
    }
    
    NSString *imageFileName = [NSString stringWithFormat:@"%@/%@", pathName, self.currentName.nameImageName];
    
    NSURL *imageFileURL = [[[ANFBStorageManager sharedManager] getDocumentsDirectory] URLByAppendingPathComponent:imageFileName];
    
    
    // *** DOWNLOAD FROM FIREBASE TO FILE AND STORE LOCALLY
    
    UIImage *nameImage = [UIImage imageWithContentsOfFile:[imageFileURL path]];
    
    if (!nameImage) {
        
        self.nameImageView.image = [UIImage imageNamed:@"Placeholder"];
        
        FIRStorageReference *imageNameRef = [[ANFBStorageManager sharedManager] getReferenceForFileName:imageFileName];
        
        FIRStorageDownloadTask *downloadTask = [imageNameRef writeToFile:imageFileURL completion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"error occured = %@", error);
                
            } else {
                UIImage* nameImage = [UIImage imageWithContentsOfFile:[imageFileURL path]];
                [self.nameImageView setImage:nameImage];
            }
        }];
        
    } else {
        
        self.nameImageView.image = nameImage;
        
    }

    
    // *** DOWNLOAD FROM FIREBASE TO MEMORY
/*
    FIRStorageReference *imageNameRef = [[ANFBStorageManager sharedManager] getReferenceForFileName:imageFileName];

    
    FIRStorageDownloadTask *downloadTask = [imageNameRef dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData *data, NSError *error){
        if (error != nil) {
            // Uh-oh, an error occurred!
            NSLog(@"error = %@",error);
        } else {
            // Data for "images/island.jpg" is returned
            UIImage *gotImage = [UIImage imageWithData:data];
            
            NSLog(@"gotImage = %@", gotImage);
            
            self.nameImageView.image = gotImage;
        }
    }];
    */

    
    // *** SET FROM APP BUNDLE ASSETS
    /*
    UIImage* imageName = [UIImage imageNamed:self.currentName.nameImageName];

    
    if (!imageName) {
        self.nameImageView.image = [UIImage imageNamed:@"Placeholder"];
    } else {
        self.nameImageView.image = imageName;
    }
    */
}

- (void) refreshLikeButton {
    if (self.isNameFavorite) {
        [self.likeButton setImage:self.likeSetImage forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:self.likeNonSetImage forState:UIControlStateNormal];
    }
}

#pragma mark - ACTIONS
- (void) actionCancel:(UIBarButtonItem*) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) actionNextPressed:(UIBarButtonItem*) sender {
    [self iterateNameWithDirection:ANNameIterationDirectionNext];
}

- (void) actionPreviousPressed:(UIBarButtonItem*) sender {
    [self iterateNameWithDirection:ANNameIterationDirectionPrevious];
}

- (void) actionShareButtonPressed:(UIBarButtonItem*) sender {
    ANName* firstName = self.currentName;
    UIImage* imageToShare = [UIImage imageNamed:firstName.nameImageName];
    [self showShareMenuActionSheetWithText:firstName.firstName Image:imageToShare andSourceForActivityVC:self.shareButton];
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
    } else {
        [[ANDataManager sharedManager] addFavoriteName:self.currentName];
    }
    
    self.isNameFavorite = !self.isNameFavorite;

    [self refreshLikeButton];
}
    
- (IBAction)actionWebButtonPressed:(UIButton*)sender {
    NSString *urlString = self.currentName.nameURL;
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    if (url != nil) {
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
        [self presentViewController:safariVC animated:true completion:nil];
    }
}



@end


