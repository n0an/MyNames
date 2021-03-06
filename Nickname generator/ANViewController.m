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
@property (strong, nonatomic) ANNamesFactory *sharedNamesFactory;

@property (assign, nonatomic) BOOL isDescriptionAvailable;
@property (assign, nonatomic) BOOL isNameFavorite;

@property (assign, nonatomic) BOOL isSettingsActive;
@property (assign, nonatomic) BOOL settingsViewPickedUp;

@property (assign, nonatomic) ANGender selectedGender;
@property (strong, nonatomic) ANNameCategory *selectedCategory;
@property (assign, nonatomic) ANTolkienRace selectedRace;

@property (strong, nonatomic) ANName *displayedName;

@property (strong, nonatomic) UIImage *likeNonSetImage;
@property (strong, nonatomic) UIImage *likeSetImage;

@property (strong, nonatomic) UIVisualEffectView *blurEffectView1;

@property (strong, nonatomic) UIView *draggingView;

@property (assign, nonatomic) CGPoint touchOffset;
@property (assign, nonatomic) CGPoint lastLocation;

@property (strong, nonatomic) id observer;
@property (strong, nonatomic) id rotateTransition;

@property (strong, nonatomic) NSArray *racesTolkienArray;
@property (strong, nonatomic) NSArray *housesGOTArray;
@property (strong, nonatomic) NSArray *racesStarwarsArray;

@property (strong, nonatomic) UILabel *raceLabel;

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
    
    self.racesTolkienArray =  @[NSLocalizedString(@"NAMERACE020200", nil),
                                NSLocalizedString(@"NAMERACE020201", nil),
                                NSLocalizedString(@"NAMERACE020202", nil),
                                NSLocalizedString(@"NAMERACE020203", nil),
                                NSLocalizedString(@"NAMERACE020204", nil),
                                NSLocalizedString(@"NAMERACE020205", nil),
                                NSLocalizedString(@"NAMERACE020206", nil),
                                NSLocalizedString(@"NAMERACE020207", nil),
                                NSLocalizedString(@"NAMERACE020208", nil)];
    
    self.housesGOTArray =     @[NSLocalizedString(@"NAMERACE020300", nil),
                                NSLocalizedString(@"NAMERACE020301", nil),
                                NSLocalizedString(@"NAMERACE020302", nil),
                                NSLocalizedString(@"NAMERACE020303", nil),
                                NSLocalizedString(@"NAMERACE020304", nil)];
    
    self.racesStarwarsArray = @[NSLocalizedString(@"NAMERACE020400", nil),
                                NSLocalizedString(@"NAMERACE020401", nil),
                                NSLocalizedString(@"NAMERACE020402", nil),
                                NSLocalizedString(@"NAMERACE020403", nil),
                                NSLocalizedString(@"NAMERACE020404", nil)];
    
    [self listenForGoingBackgroundNotification];
    
    self.rotateTransition   = [[ANRotateTransitionAnimator alloc] init];
    self.sharedNamesFactory = [ANNamesFactory sharedFactory];
    self.selectedCategory   = [self.sharedNamesFactory.namesCategories objectAtIndex:0];
    
    self.selectedRace = ANTolkienRaceAll;
    
    [self.nameCategorySelectButton setTitle:self.selectedCategory.nameCategoryTitle forState:UIControlStateNormal];
    
    self.selectedGender = ANGenderAll;
    
    self.isDescriptionAvailable = NO;
    self.isSettingsActive = NO;
    
    [self animateResultsLabelUpdate];
    
    self.infoButton.layer.cornerRadius = self.infoButton.bounds.size.width / 2.f;
    
    self.infoButton.layer.masksToBounds = YES;
    
    UIBlurEffect *lightBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *lightBlurEffectView = [[UIVisualEffectView alloc] initWithEffect:lightBlurEffect];
    
    [self.bgImageView setImage:[UIImage imageNamed:@"diceBG03_1920"]];
    
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
    
    
#if !PRODUCTION_BUILD
    
    [self addUploadButton];
    
#endif
    
    UIImage *splashImage = [UIImage imageNamed:@"Eye_of_Horus"];
    
    CGSize splashImageSize = CGSizeMake(150, 100);
    
//    UIColor *splashImageBGColor = [UIColor whiteColor];
    
//    UIColor *splashImageBGColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    
    UIColor *splashImageBGColor = [UIColor colorWithRed:236/255.0 green:240/255.0 blue:241/255.0 alpha:1.0];

    RevealingSplashView *splashView = [[RevealingSplashView alloc] initWithIconImage:splashImage iconInitialSize:splashImageSize backgroundColor:splashImageBGColor];
    
    [self.view addSubview:splashView];
    
    splashView.minimumBeats = 2;
    
    [splashView playHeartBeatAnimation:^{
//        [splashView finishHeartBeatAnimation];
    }];
    
    
//    [splashView startAnimation:nil];

//    splashView.heartAttack = YES;
    [splashView finishHeartBeatAnimation];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    [self checkUserDefaultsFirstLaunch];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self animateGenerateButton];
    
    self.nameCategoryLabel.userInteractionEnabled    = YES;
    
    UITapGestureRecognizer* tapCategoryGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapOnCategoryLabel:)];
    
    [self.nameCategoryLabel addGestureRecognizer:tapCategoryGesture];
    
    // Setting gesture recognizer for main label
    if (self.isDescriptionAvailable) {
        self.nameResultLabel.userInteractionEnabled = YES;
        self.infoButton.hidden = NO;
    } else {
        self.nameResultLabel.userInteractionEnabled = NO;
        self.infoButton.hidden = YES;
    }
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapOnNameLabel:)];
    
    [self.nameResultLabel addGestureRecognizer:tapGesture];
    
    self.isNameFavorite = [[ANDataManager sharedManager] isNameFavorite:self.displayedName];
    [self refreshLikeButton];
    
    UITapGestureRecognizer* tapGestureOnWheelView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapOnWheelView:)];
    [self.wheelView addGestureRecognizer:tapGestureOnWheelView];
    
    [self.view layoutIfNeeded];
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

- (NSString *) getNewNameAndSetInfoButton {
    
    ANName *name;
    
    if ([self.selectedCategory.nameCategoryID isEqualToString:@"02.02"]) {
        
        name = [[ANNamesFactory sharedFactory] getRandomTolkienForRace:self.selectedRace andGender:self.selectedGender];
        
    } else if ([self.selectedCategory.nameCategoryID isEqualToString:@"02.03"]) {
        name = [[ANNamesFactory sharedFactory] getRandomGOTForHouse:(ANGOTHouse)self.selectedRace andGender:self.selectedGender];
        
    } else if ([self.selectedCategory.nameCategoryID isEqualToString:@"02.04"]) {
        name = [[ANNamesFactory sharedFactory] getRandomStarwarsForRace:(ANStarwarsRace)self.selectedRace andGender:self.selectedGender];
        
    } else {
        name = [[ANNamesFactory sharedFactory] getRandomNameForCategory:self.selectedCategory andGender:self.selectedGender];
    }
    
    if (name.nameDescription && ![name.nameDescription isEqualToString:@""]) {
        self.isDescriptionAvailable = YES;
        self.nameResultLabel.userInteractionEnabled = YES;
        self.infoButton.hidden = NO;
    } else {
        self.isDescriptionAvailable = NO;
        self.nameResultLabel.userInteractionEnabled = NO;
        self.infoButton.hidden = YES;
    }
    
    self.displayedName = name;
    
    NSString* genderImage = !name.nameGender ? @"masc02" : @"fem02";
    
    self.genderImageView.image = [UIImage imageNamed:genderImage];

    return name.firstName;
}

- (void) refreshLikeButton {
    if (self.isNameFavorite) {
        [self.likeButton setImage:self.likeSetImage forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:self.likeNonSetImage forState:UIControlStateNormal];
    }
}
    
- (void) addUploadButton {
    
    UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [uploadButton setTitle:@"!!!UPLOAD!!!" forState:UIControlStateNormal];
    [uploadButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [uploadButton addTarget:self action:@selector(uploadPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:uploadButton];
    
    [uploadButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [[uploadButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:70] setActive:YES];
    [[uploadButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:0] setActive:YES];
}

- (void) uploadUsingFileManager {
    
    NSLog(@"uploadUsingFileManager");
    
    // *** !!! SET THIS TWO PARAMETERS IN ACCORDANCE WITH CONTENTS OF !TOUPLOAD DIRECTORY !!!
    ANNameCategory* category = self.selectedCategory;
    ANGender gender = self.selectedGender;
    
    if ([category.nameCategoryID isEqualToString:@"00.00"]) {
        return;
    }
    
    if (gender == ANGenderAll) {
        return;
    }
    
    // ** Contents of !ToUpload directory
    NSURL *documentsURL = [[ANFBStorageManager sharedManager] getDocumentsDirectory];
    
    NSURL *uploadFolderURL = [documentsURL URLByAppendingPathComponent:@"!ToUpload"];
    
    NSError *err;
    
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[uploadFolderURL path] error:&err];
    
    // ** Getting pathName in accordance with category and gender
    NSString *genderString;
    
    if (gender == ANGenderMasculine) {
        genderString = @"Masc";
    } else {
        genderString = @"Fem";
    }
    
    NSString* pathName = [category.alias stringByAppendingString:genderString];
    
    
    // ** Getting checking prefix
    
    NSString *checkingPrefix;
    
    if ([self.selectedCategory.nameCategoryID isEqualToString:@"02.02"]) {
        NSString *raceString = [ANName getTolkienRaceStringForRace:self.selectedRace];
        checkingPrefix = [NSString stringWithFormat:@"%@%@%@", category.alias, raceString, genderString];
        
    } else if ([self.selectedCategory.nameCategoryID isEqualToString:@"02.03"]) {
        
        NSString *houseString = [ANName getGOTHouseStringForHouse: (ANGOTHouse)self.selectedRace];
        
        checkingPrefix = [NSString stringWithFormat:@"%@%@%@", category.alias, houseString, genderString];
        
    } else if ([self.selectedCategory.nameCategoryID isEqualToString:@"02.04"]) {
        
        NSString *raceString = [ANName getStarwarsRaceStringForRace: (ANStarwarsRace)self.selectedRace];
        
        checkingPrefix = [NSString stringWithFormat:@"%@%@%@", category.alias, raceString, genderString];
        
    } else {
        checkingPrefix = pathName;
    }
    
    // ** Uploads counter
    __block NSInteger imagesLoadedCount = 0;
    
    // ** Main cycle
    for (NSString *fullFileName in fileList) {
        
        if (![fullFileName hasPrefix:checkingPrefix]) {
            continue;
        }
        
        NSArray *fileNameComponents = [fullFileName componentsSeparatedByString:@"."];
        
        NSString *fileName = [fileNameComponents firstObject];
        
        NSString *nameImageFileName = [NSString stringWithFormat:@"%@Images/%@", pathName, fileName];
        
        FIRStorageReference *dirRef = [[ANFBStorageManager sharedManager] getReferenceForFileName:nameImageFileName];
        
        NSURL* imageFileURL = [uploadFolderURL URLByAppendingPathComponent:fullFileName];
        
        FIRStorageUploadTask *uploadTask = [dirRef putFile:imageFileURL metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
            
            if (error != nil) {
                NSLog(@"Error Uploading: %@", error);
                
            } else {
                imagesLoadedCount++;
                NSLog(@"-- %ld. Uploaded: %@", (long)imagesLoadedCount, fileName);
            }
        }];
    }
}

- (void) uploadUsingRecodingToJPG {
    
    // *** !!! SET THIS TWO PARAMETERS IN ACCORDANCE WITH CONTENTS OF !TOUPLOAD DIRECTORY !!!
    ANNameCategory* category = self.selectedCategory;
    ANGender gender = self.selectedGender;
    
    // ** Getting pathName in accordance with category and gender
    NSString* pathName;
    
    if (gender == ANGenderMasculine) {
        pathName = [category.alias stringByAppendingString:@"Masc"];
    } else {
        pathName = [category.alias stringByAppendingString:@"Fem"];
    }
    
    // *** CYCLING THROUGH ALL NAMES FROM PLIST FILE
    NSString *path = [[NSBundle mainBundle] pathForResource:pathName ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray* namesArr = [dict allKeys];
    
    __block NSInteger imagesLoadedCount = 0;
    
    for (NSString *name in namesArr) {
        
        NSDictionary *nameParams = [dict objectForKey:name];
        
        NSString *nameImageName = [nameParams objectForKey:@"nameImageName"];
        
        UIImage *imageToUpload = [UIImage imageNamed:nameImageName];
        
        if (imageToUpload) {
            
            NSString *nameImageFileName = [NSString stringWithFormat:@"%@Images/%@.jpg", pathName, nameImageName];
            
            FIRStorageReference *dirRef = [[ANFBStorageManager sharedManager] getReferenceForFileName:nameImageFileName];
            
            NSData* imageData = UIImageJPEGRepresentation(imageToUpload, 1.0);
            
            FIRStorageUploadTask *uploadTask = [dirRef putData:imageData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
                
                if (error != nil) {
                    NSLog(@"Error Uploading: %@", error);
                } else {
                    imagesLoadedCount++;
                    NSLog(@"-- %ld. Uploaded: %@", (long)imagesLoadedCount, nameImageName);
                }
            }];
        }
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
                         
                         self.nameResultLabel.text = [self getNewNameAndSetInfoButton];
                         
                         self.isNameFavorite = [[ANDataManager sharedManager] isNameFavorite:self.displayedName];
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
        [self animateResultsLabelUpdate];
    }
}

- (IBAction)actionGenerateButtonPressed:(UIButton*)sender {
    [self animateGenerateButtonOnClick];
    [self animateResultsLabelUpdate];
}

- (IBAction)actionlikeButtonPressed:(UIButton*)sender {
    
    ANName* currentName = self.displayedName;
    
    if (self.isNameFavorite) {
        [[ANDataManager sharedManager] deleteFavoriteName:currentName];
    } else {
        [[ANDataManager sharedManager] addFavoriteName:currentName];
    }
    
    self.isNameFavorite = !self.isNameFavorite;
    [self refreshLikeButton];
}

- (IBAction)actionShareButtonPressed:(UIButton*)sender {
    
    ANName* currentName = self.displayedName;
    
    UIImage* imageToShare = [UIImage imageNamed:currentName.nameImageName];
    
    [self showShareMenuActionSheetWithText:currentName.firstName Image:imageToShare andSourceForActivityVC:self.view];
}

- (IBAction)actionGndrBtnPressed:(id)sender {
    
    UIImage* mascActiveImage = [UIImage imageNamed:@"masc01"];
    UIImage* mascNonactiveImage = [UIImage imageNamed:@"masc02"];
    
    UIImage* femActiveImage = [UIImage imageNamed:@"fem01"];
    UIImage* femNonactiveImage = [UIImage imageNamed:@"fem02"];
    
    if ([sender isEqual:self.genderButtonMasc]) {
        
        if (self.selectedGender == ANGenderAll || self.selectedGender == ANGenderFeminine) {
            self.selectedGender = ANGenderMasculine;
            
            [self.genderButtonMasc setImage:mascActiveImage forState:UIControlStateNormal];
            [self.genderButtonFem setImage:femNonactiveImage forState:UIControlStateNormal];
            
        } else if (self.selectedGender == ANGenderMasculine) {
            self.selectedGender = ANGenderAll;
            
            [self.genderButtonMasc setImage:mascNonactiveImage forState:UIControlStateNormal];
            [self.genderButtonFem setImage:femNonactiveImage forState:UIControlStateNormal];
        }
        
    } else if ([sender isEqual:self.genderButtonFem]) {
        
        if (self.selectedGender == ANGenderAll || self.selectedGender == ANGenderMasculine) {
            self.selectedGender = ANGenderFeminine;
            
            [self.genderButtonMasc setImage:mascNonactiveImage forState:UIControlStateNormal];
            [self.genderButtonFem setImage:femActiveImage forState:UIControlStateNormal];
            
        } else if (self.selectedGender == ANGenderFeminine) {
            self.selectedGender = ANGenderAll;
            
            [self.genderButtonMasc setImage:mascNonactiveImage forState:UIControlStateNormal];
            [self.genderButtonFem setImage:femNonactiveImage forState:UIControlStateNormal];
        }
    }
    
    [self animateResultsLabelUpdate];
}

- (IBAction)actionTapOnInfoButton:(id)sender {
    if (self.isDescriptionAvailable) {
        
        [self performSegueWithIdentifier:@"showDescriptionVC" sender:nil];
    }
}

- (void) actionTapOnNameLabel:(UITapGestureRecognizer*) recognizer {
    if (self.isDescriptionAvailable) {
        
        [self performSegueWithIdentifier:@"showDescriptionVC" sender:nil];
    }
}

- (void) showCategorySelection {
    ANCategoryVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ANCategoryVC"];
    
    vc.categories = self.sharedNamesFactory.namesCategories;
    vc.selectedCategory = self.selectedCategory;
    vc.delegate = self;
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) actionTapOnCategoryLabel:(UITapGestureRecognizer*) recognizer {
    [self showCategorySelection];
}

- (IBAction)actionCategorySelectButtonPressed:(UIButton*)sender {
    [self showCategorySelection];
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
    [self uploadUsingFileManager];
}

- (IBAction)actionRaceSelectButtonPressed:(UIButton*)sender {
    [self.raceSelectionPickerView setFrame:self.controlsView.bounds];
    [self.controlsView addSubview:self.raceSelectionPickerView];
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
        destinationVC.selectedName = self.displayedName;
        
        if (iPhone()) {
            destinationNavVC.transitioningDelegate = self.rotateTransition;
        }
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([self.selectedCategory.nameCategoryID isEqualToString:@"02.02"]) {
        return 9;
    } else if ([self.selectedCategory.nameCategoryID isEqualToString:@"02.03"]) {
        return 5;
    } else {
        return 5;
    }
    
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title;
    
    if ([self.selectedCategory.nameCategoryID isEqualToString:@"02.02"]) {
        
        title = self.racesTolkienArray[row];
        
    } else if ([self.selectedCategory.nameCategoryID isEqualToString:@"02.03"]) {
        title = self.housesGOTArray[row];
        
    } else {
        title = self.racesStarwarsArray[row];
    }
    
   
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *title;
    
    if ([self.selectedCategory.nameCategoryID isEqualToString:@"02.02"]) {
        title = self.racesTolkienArray[row];
        
    } else if ([self.selectedCategory.nameCategoryID isEqualToString:@"02.03"]) {
        title = self.housesGOTArray[row];

    } else {
        title = self.racesStarwarsArray[row];
    }
    
    self.selectedRace = (ANTolkienRace)row;
    
    [self.nameRaceSelectButton setTitle:title forState:UIControlStateNormal];
    [self.raceSelectionPickerView removeFromSuperview];
    [self animateResultsLabelUpdate];
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
        UIImage* bgImage = [UIImage imageNamed:@"diceBG03_1920"];
        [self.bgImageView setImage:bgImage];
    }
    
    self.selectedRace = ANTolkienRaceAll;

    self.nameResultLabel.text = [self getNewNameAndSetInfoButton];
    
    
    [self.nameCategorySelectButton setTitle:self.selectedCategory.nameCategoryTitle forState:UIControlStateNormal];
    
    BOOL isTolkienCategory = [category.nameCategoryID isEqualToString:@"02.02"];
    BOOL isGOTCategory = [category.nameCategoryID isEqualToString:@"02.03"];
    BOOL isStarwarsCategory = [category.nameCategoryID isEqualToString:@"02.04"];

    if (isTolkienCategory || isGOTCategory || isStarwarsCategory) {
        
        [self.controlsStackView setSpacing:8];
        
        NSString *raceLabelText;
        
        if (isTolkienCategory || isStarwarsCategory) {
            raceLabelText = NSLocalizedString(@"UILABEL_RACE", nil);
        } else {
            raceLabelText = NSLocalizedString(@"UILABEL_HOUSE", nil);
        }
        
        
        if (self.raceLabel == nil) {
            
            CGRect raceLabelFrame = CGRectMake(0, 0, 80, 30);
            UILabel *raceLabel = [[UILabel alloc] initWithFrame:raceLabelFrame];
            
            self.raceLabel = raceLabel;
            
        }
        
        [self.categoryRaceLabelsStackView addArrangedSubview:self.raceLabel];
        
        self.raceLabel.text = raceLabelText;
        self.raceLabel.hidden = NO;
        
        [self.categoryRaceButtonsStackView addArrangedSubview:self.nameRaceSelectButton];
        self.nameRaceSelectButton.hidden = NO;
        
        NSString *currentRaceTitle = self.racesTolkienArray[0];
        
        [self.nameRaceSelectButton setTitle:currentRaceTitle forState:UIControlStateNormal];
        
        [self.raceSelectionPickerView reloadAllComponents];
        [self.raceSelectionPickerView selectRow:0 inComponent:0 animated:NO];

    } else {
        NSLog(@"here");
        if (self.categoryRaceButtonsStackView.arrangedSubviews.count == 2) {
            [self.controlsStackView setSpacing:40];
            [self.categoryRaceLabelsStackView removeArrangedSubview:self.raceLabel];
            self.raceLabel.hidden = YES;
            [self.categoryRaceButtonsStackView removeArrangedSubview:self.nameRaceSelectButton];
            self.nameRaceSelectButton.hidden = YES;
        }
    }
}

@end

