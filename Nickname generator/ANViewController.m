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
#import "ANPageViewController.h"
#import "ANRotateTransitionAnimator.h"
#import "UIViewController+ANAlerts.h"
#import "ANFBStorageManager.h"
#import <FirebaseStorage/FirebaseStorage.h>
#import "ANFRImage.h"

#pragma mark - ENUM
typedef enum {
    ANMenuConstantStateClosed       = -321,
    ANMenuConstantStateThreshold    = -100,
    ANMenuConstantStateOpened       = 1
} ANMenuConstantState;

#pragma mark - CONSTANTS
extern NSString* const kAppAlreadySeen;
extern NSString* const kAppLaunchesCount;

@interface ANViewController () <ANCategorySelectionDelegate>

#pragma mark - PRIVATE PROPERTIES
@property (strong, nonatomic) ANNamesFactory* sharedNamesFactory;

@property (assign, nonatomic) BOOL isDescriptionAvailable;
@property (assign, nonatomic) BOOL isNameFavorite;

@property (assign, nonatomic) BOOL isSettingsActive;
@property (assign, nonatomic) BOOL settingsViewPickedUp;

@property (assign, nonatomic) NSInteger namesCount;
@property (assign, nonatomic) ANGender selectedGender;
@property (strong, nonatomic) ANNameCategory* selectedCategory;

@property (strong, nonatomic) NSArray* displayedNames;
@property (strong, nonatomic) NSArray* namesWithDescriptions;

@property (strong, nonatomic) UIImage* likeNonSetImage;
@property (strong, nonatomic) UIImage* likeSetImage;

@property (strong, nonatomic) UIVisualEffectView* blurEffectView1;

@property (strong, nonatomic) UIView* draggingView;

@property (assign, nonatomic) CGPoint touchOffset;
@property (assign, nonatomic) CGPoint lastLocation;

@property (strong, nonatomic) id observer;
@property (strong, nonatomic) id rotateTransition;

@end

@implementation ANViewController

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}



#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self listenForGoingBackgroundNotification];
    
    self.rotateTransition   = [[ANRotateTransitionAnimator alloc] init];
    self.sharedNamesFactory = [ANNamesFactory sharedFactory];
    self.selectedCategory   = [self.sharedNamesFactory.namesCategories objectAtIndex:0];
    
    self.nameCategoryLabel.text = self.selectedCategory.nameCategoryTitle;
    
    self.namesCount = self.nameCountControl.selectedSegmentIndex + 1;
    
    self.selectedGender = ANGenderMasculine;
    
    self.isDescriptionAvailable = NO;
    self.isSettingsActive = NO;
    
    self.nameResultLabel.text = [self getNamesStringForNamesCount:self.namesCount];
    
    UIBlurEffect *lightBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *lightBlurEffectView = [[UIVisualEffectView alloc] initWithEffect:lightBlurEffect];
    
    [self.bgImageView setImage:[UIImage imageNamed:self.selectedCategory.nameCategoryBackgroundImageName]];
    
    lightBlurEffectView.frame = self.controlsView.bounds;
    [self.controlsView insertSubview:lightBlurEffectView atIndex:0];
    
    self.controlsView.clipsToBounds = YES;
    self.controlsView.layer.cornerRadius = 10.f;
    
    UIBlurEffect *lightBlurEffect1 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *lightBlurEffectView1 = [[UIVisualEffectView alloc] initWithEffect:lightBlurEffect1];
    
    lightBlurEffectView1.frame = self.wheelView.bounds;
    [self.wheelView insertSubview:lightBlurEffectView1 atIndex:0];
    self.wheelView.clipsToBounds = YES;
    
    self.blurEffectView1 = lightBlurEffectView1;
    
    self.generateButton.transform = CGAffineTransformMakeScale(0.f, 0.f);
    
    self.likeNonSetImage = [UIImage imageNamed:@"like1"];
    self.likeSetImage = [UIImage imageNamed:@"like1set"];
    
    [self checkUserDefaultsLaunchesCount];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    [self checkUserDefaultsFirstLaunch];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self animateGenerateButton];
    
    self.nameCategoryLabel.userInteractionEnabled       = YES;
    self.nameCategoryLabelTag.userInteractionEnabled    = YES;
    
    UITapGestureRecognizer* tapCategoryGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapOnCategoryLabel:)];
    UITapGestureRecognizer* tapCategoryGestureTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapOnCategoryLabel:)];
    
    [self.nameCategoryLabel addGestureRecognizer:tapCategoryGesture];
    [self.nameCategoryLabelTag addGestureRecognizer:tapCategoryGestureTag];
    
    // Setting gesture recognizer for main label
    if (self.isDescriptionAvailable) {
        self.nameResultLabel.userInteractionEnabled = YES;
        self.infoImageView.hidden = NO;
    } else {
        self.nameResultLabel.userInteractionEnabled = NO;
        self.infoImageView.hidden = YES;
    }
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapOnNameLabel:)];
    
    [self.nameResultLabel addGestureRecognizer:tapGesture];
    
    ANName* firstName = [self.displayedNames firstObject];
    
    self.isNameFavorite = [[ANDataManager sharedManager] isNameFavorite:firstName];
    [self refreshLikeButton];
    
    UITapGestureRecognizer* tapGestureOnWheelView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapOnWheelView:)];
    [self.wheelView addGestureRecognizer:tapGestureOnWheelView];
}

- (void) deinit {
    if (self.observer != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - HELPER METHODS
- (void) checkUserDefaultsFirstLaunch {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL appAlreadySeen = [userDefaults boolForKey:kAppAlreadySeen];
    
    if (!appAlreadySeen) {
        
        ANPageViewController* pageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ANPageViewController"];
        
        [self presentViewController:pageVC animated:YES completion:nil];
    }
}

- (void) checkUserDefaultsLaunchesCount {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger appLaunchesCount = [userDefaults integerForKey:kAppLaunchesCount];
    
    ANLog(@"appLaunchesCount = %d", appLaunchesCount);
    
    if (appLaunchesCount < 10) {
        [self animateWheelRotating];
    }
}

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
        self.nameResultLabel.userInteractionEnabled = YES;
        self.infoImageView.hidden = NO;
    } else {
        self.isDescriptionAvailable = NO;
        self.nameResultLabel.userInteractionEnabled = NO;
        self.infoImageView.hidden = YES;
    }
    
    NSArray* resArray = cleanArray;
    
    return resArray;
}

- (void) refreshLikeButton {
    if (self.isNameFavorite) {
        [self.likeButton setImage:self.likeSetImage forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:self.likeNonSetImage forState:UIControlStateNormal];
    }
}


#pragma mark - NOTIFICATIONS
- (void) listenForGoingBackgroundNotification {
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    self.observer = [center addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if (self.presentedViewController != nil) {
            [self dismissViewControllerAnimated:false completion:nil];
        }
    }];
}

#pragma mark - ANIMATIONS

- (void) animateGenerateButton {
    
    [UIView animateWithDuration:0.7f
                          delay:0.f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.generateButton.transform = CGAffineTransformMakeScale(1.f, 1.f);
                     } completion:nil];
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

- (void) animateResultsLabelUpdate {
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.nameResultLabel.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         
                         NSString* currentNamesLabel = [self getNamesStringForNamesCount:self.namesCount];
                         
                         self.nameResultLabel.text = currentNamesLabel;
                         
                         NSArray* arr = self.displayedNames;
                         
                         ANName* firstName = [arr firstObject];
                         
                         self.isNameFavorite = [[ANDataManager sharedManager] isNameFavorite:firstName];
                         [self refreshLikeButton];
                         
                         [UIView animateWithDuration:0.5f
                                          animations:^{
                                              self.nameResultLabel.alpha = 1.f;
                                          }];
                     }];
}

- (void) animateWheelRotating {
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.wheelView.transform = CGAffineTransformMakeRotation(M_PI/2);
                     } completion:^(BOOL finished) {
                         self.wheelView.transform = CGAffineTransformIdentity;
                         [self animateWheelFlapOnLaunch];
                     }];
}

- (void) animateWheelFlapOnLaunch {
    
    [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            self.settingsViewLeadingConstraint.constant = -270;
            [self.view layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.25 animations:^{
            self.settingsViewLeadingConstraint.constant = ANMenuConstantStateClosed;
            [self.view layoutIfNeeded];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.125 animations:^{
            self.settingsViewLeadingConstraint.constant = -290;
            [self.view layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.875 relativeDuration:0.125 animations:^{
            self.settingsViewLeadingConstraint.constant = ANMenuConstantStateClosed;
            [self.view layoutIfNeeded];
        }];
        
    } completion:nil];
}

#pragma mark - ACTIONS
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (UIEventSubtypeMotionShake) {
        
        ANLog(@"I'm shaking!");
        
        [self animateResultsLabelUpdate];
    }
}

- (IBAction)actionGenerateButtonPressed:(UIButton*)sender {
    [self animateGenerateButtonOnClick];
    [self animateResultsLabelUpdate];
}

- (IBAction)actionlikeButtonPressed:(UIButton*)sender {
    
    // *** Saving choosen names to CoreData
    NSArray* arr = self.displayedNames;
    
    ANName* currentName = [arr firstObject];
    
    if (self.isNameFavorite) {
        [[ANDataManager sharedManager] deleteFavoriteName:currentName];
    } else {
        [[ANDataManager sharedManager] addFavoriteName:currentName];
    }
    
    self.isNameFavorite = !self.isNameFavorite;
    
    [self refreshLikeButton];
}

- (IBAction)actionShareButtonPressed:(UIButton*)sender {
    
    ANName* firstName = [self.displayedNames objectAtIndex:0];
    
    UIImage* imageToShare = [UIImage imageNamed:firstName.nameImageName];
    
    [self showShareMenuActionSheetWithText:firstName.firstName Image:imageToShare andSourceForActivityVC:self.view];
}


- (IBAction)actionNameCountControlValueChanged:(UISegmentedControl*)sender {
    ANLog(@"New value is = %d", sender.selectedSegmentIndex);
    self.namesCount = sender.selectedSegmentIndex + 1;
}

- (IBAction)actionGndrBtnPressed:(id)sender {
    UIImage* mascActiveImage = [UIImage imageNamed:@"masc01"];
    UIImage* mascNonactiveImage = [UIImage imageNamed:@"masc02"];
    
    UIImage* femActiveImage = [UIImage imageNamed:@"fem01"];
    UIImage* femNonactiveImage = [UIImage imageNamed:@"fem02"];
    
    if ([sender isEqual:self.genderButtonMasc]) {
        self.selectedGender = ANGenderMasculine;
        
        self.imgViewGenderMasc.image = mascActiveImage;
        self.imgViewGenderFem.image = femNonactiveImage;
        
    } else if ([sender isEqual:self.genderButtonFem]) {
        self.selectedGender = ANGenderFeminine;
        
        self.imgViewGenderMasc.image = mascNonactiveImage;
        self.imgViewGenderFem.image = femActiveImage;
    }
}


- (void) actionTapOnNameLabel:(UITapGestureRecognizer*) recognizer {
    if (self.isDescriptionAvailable) {
        
        [self performSegueWithIdentifier:@"showDescriptionVC" sender:nil];
    }
}

- (void) actionTapOnCategoryLabel:(UITapGestureRecognizer*) recognizer {
    
    ANCategoryVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ANCategoryVC"];
    
    vc.categories = self.sharedNamesFactory.namesCategories;
    vc.selectedCategory = self.selectedCategory;
    vc.delegate = self;
    
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) actionTapOnWheelView:(UITapGestureRecognizer*) recognizer {
    
    [UIView animateWithDuration:0.1f animations:^{
        self.wheelView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
        self.wheelView.alpha = 0.8f;
    } completion:^(BOOL finished) {
        self.wheelView.transform = CGAffineTransformIdentity;
        self.wheelView.alpha = 1.f;
    }];
    
    NSInteger newConstant;
    UIViewAnimationOptions options;
    
    if (self.isSettingsActive) {
        options = UIViewAnimationOptionCurveEaseIn;
        newConstant = ANMenuConstantStateClosed;
    } else {
        options = UIViewAnimationOptionCurveEaseOut;
        newConstant = ANMenuConstantStateOpened;
    }
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:options
                     animations:^{
                         self.settingsViewLeadingConstraint.constant = newConstant;
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
    
    self.isSettingsActive = !self.isSettingsActive;
}

- (IBAction) uploadPressed {
    
    ANNameCategory* category = [[ANNamesFactory sharedFactory] getCategoryForID:@"01.05"];
    
    ANGender* gender = ANGenderFeminine;
    
    NSString* pathName;
    
    if (gender == ANGenderMasculine) {
        pathName = [category.alias stringByAppendingString:@"Masc"];
    } else {
        pathName = [category.alias stringByAppendingString:@"Fem"];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:pathName ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray* namesArr = [dict allKeys];
    
    __block NSInteger imagesLoadedCount = 0;
    
    for (NSString *name in namesArr) {
        
        NSDictionary *nameParams = [dict objectForKey:name];
        
        NSString *nameImageName = [nameParams objectForKey:@"nameImageName"];
        
        NSURL* documentsURL = [[ANFBStorageManager sharedManager] getDocumentsDirectory];
        
        NSString *fileNameWithExt = [nameImageName stringByAppendingString:@".jpg"];
        
        NSURL *imageFileURL = [documentsURL URLByAppendingPathComponent:fileNameWithExt];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[imageFileURL path]]) {
            
            NSString *nameImageFileName = [NSString stringWithFormat:@"%@Images/%@.jpg", pathName, nameImageName];
            
            FIRStorageReference *dirRef = [[ANFBStorageManager sharedManager] getReferenceForFileName:nameImageFileName];
            
            FIRStorageUploadTask *uploadTask = [dirRef putFile:imageFileURL metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
                
                if (error != nil) {
                    NSLog(@"Error Uploading: %@", error);
                } else {
                    
                    NSURL *downloadURL = metadata.downloadURL;
                    imagesLoadedCount++;
                    NSLog(@"-- %d. Uploaded: %@", imagesLoadedCount, nameImageName);
                }
            }];

            
        }
        
        
//        if (imageFileURL) {
//            
//            NSString *nameImageFileName = [NSString stringWithFormat:@"%@Images/%@", pathName, nameImageName];
//            
//            FIRStorageReference *dirRef = [[ANFBStorageManager sharedManager] getReferenceForFileName:nameImageFileName];
//            
//            FIRStorageUploadTask *uploadTask = [dirRef putFile:imageFileURL metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
//                
//                if (error != nil) {
//                    // Uh-oh, an error occurred!
//                } else {
//                    // Metadata contains file metadata such as size, content-type, and download URL.
//                    NSURL *downloadURL = metadata.downloadURL;
//                }
//            }];
//            
//        }
        
        
//        UIImage *imageToUpload = [UIImage imageNamed:nameImageName];
//        
//        if (imageToUpload) {
//            
//            NSString *nameImageFileName = [NSString stringWithFormat:@"%@Images/%@", pathName, nameImageName];
//            
//            FIRStorageReference *dirRef = [[ANFBStorageManager sharedManager] getReferenceForFileName:nameImageFileName];
//            
////            NSData *imageData = [UIImageJPEGRepresentation(imageToUpload, 1.0)];
//            
//            FIRStorageDownloadTask *downloadTask = [bgRef writeToFile:bgImageFileURL completion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
//                
//                if (error) {
//                    NSLog(@"error occured = %@", error);
//                    
//                } else {
//                    NSString* filePath = [bgImageFileURL path];
//                    UIImage* bgImage = [UIImage imageWithContentsOfFile:filePath];
//                    [self.bgImageView setImage:bgImage];
//                }
//            }];
//            
//            
//        }
        
        
    }
    
    
}

#pragma mark - TOUCHES
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.view];
    
    UIView* view = [self.view hitTest:touchPoint withEvent:event];
    
    if ([view isEqual:self.blurEffectView1]) {
        self.lastLocation = touchPoint;
        self.settingsViewPickedUp = YES;
        
        [UIView animateWithDuration:0.1f animations:^{
            self.wheelView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
            self.wheelView.alpha = 0.8f;
        }];
    }
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.settingsViewPickedUp) {
        UITouch* touch = [touches anyObject];
        
        CGPoint touchPoint = [touch locationInView:self.view];
        
        CGFloat translationX = touchPoint.x - self.lastLocation.x;
        
        CGFloat nextConstant = self.settingsViewLeadingConstraint.constant + translationX;
        
        if (ANMenuConstantStateClosed <= nextConstant && nextConstant <= ANMenuConstantStateOpened) {
            self.settingsViewLeadingConstraint.constant = nextConstant;
            
            self.lastLocation = touchPoint;
            
        } else {
            
            if (self.settingsViewLeadingConstraint.constant > ANMenuConstantStateThreshold) {
                self.settingsViewLeadingConstraint.constant = ANMenuConstantStateOpened;
                self.isSettingsActive = YES;
            }
            
            self.settingsViewPickedUp = NO;
        }
        
        self.lastLocation = touchPoint;
        
        [self.view layoutIfNeeded];
    }
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [UIView animateWithDuration:0.1f animations:^{
        self.wheelView.transform = CGAffineTransformIdentity;
        self.wheelView.alpha = 1.f;
    }];
    
    self.settingsViewPickedUp = NO;
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.settingsViewPickedUp = NO;
}



#pragma mark - NAVIGATION
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDescriptionVC"]) {
        
        UINavigationController *destinationNavVC = segue.destinationViewController;
        
        ANDescriptioinVC *destinationVC = (ANDescriptioinVC*) destinationNavVC.topViewController;
        
        destinationVC.namesArray = self.namesWithDescriptions;
        
        destinationNavVC.transitioningDelegate = self.rotateTransition;
    }
}

#pragma mark - +++ ANCategorySelectionDelegate +++
- (void) categoryDidSelect:(ANNameCategory*) category {
    
    self.selectedCategory = category;
    
    if (![category.nameCategoryID isEqualToString:@"00.00"]) {
        
        NSString* bgFileName = [NSString stringWithFormat:@"Backgrounds/%@.jpg", category.alias];
        
        NSURL* bgImageFileURL = [[[ANFBStorageManager sharedManager] getDocumentsDirectory] URLByAppendingPathComponent:bgFileName];
        
        UIImage* bgImage = [UIImage imageWithContentsOfFile:[bgImageFileURL path]];
        
        if (!bgImage) {
            
            FIRStorageReference *bgRef = [[ANFBStorageManager sharedManager] getReferenceForFileName:bgFileName];
            
            FIRStorageDownloadTask *downloadTask = [bgRef writeToFile:bgImageFileURL completion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                
                if (error) {
                    NSLog(@"error occured = %@", error);
                    
                } else {
                    NSString* filePath = [bgImageFileURL path];
                    UIImage* bgImage = [UIImage imageWithContentsOfFile:filePath];
                    [self.bgImageView setImage:bgImage];
                }
            }];
            
        } else {
            
            [self.bgImageView setImage:bgImage];
        }
        
    } else {
        UIImage* bgImage = [UIImage imageNamed:self.selectedCategory.nameCategoryBackgroundImageName];
        [self.bgImageView setImage:bgImage];
    }
    
    self.nameResultLabel.text = [self getNamesStringForNamesCount:self.namesCount];
    self.nameCategoryLabel.text = self.selectedCategory.nameCategoryTitle;
}


@end

