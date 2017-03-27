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

#import <Social/Social.h>

typedef enum {
    ANMenuConstantStateClosed = -321,
    ANMenuConstantStateOpened = 1
} ANMenuConstantState;

extern NSString* const kAppAlreadySeen;
extern NSString* const kAppLaunchesCount;

@interface ANViewController () <ANCategorySelectionDelegate>

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self listenForGoingBackgroundNotification];
    
    self.rotateTransition = [[ANRotateTransitionAnimator alloc] init];
    
    self.sharedNamesFactory = [ANNamesFactory sharedFactory];
    
    self.selectedCategory = [self.sharedNamesFactory.namesCategories objectAtIndex:0];
    
    self.nameCategoryLabel.text = self.selectedCategory.nameCategoryTitle;
    
    self.namesCount = self.nameCountControl.selectedSegmentIndex + 1;
    
    self.selectedGender = ANGenderMasculine;
    
    self.isDescriptionAvailable = NO;
    self.isSettingsActive = NO;
    
    NSString* currentNamesLabel = [self getNamesStringForNamesCount:self.namesCount];
    
    self.nameResultLabel.text = currentNamesLabel;
    
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
    
    [self animateWheelRotating];
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    [self checkUserDefaults];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self animateGenerateButton];
    
    self.nameCategoryLabel.userInteractionEnabled = YES;
    self.nameCategoryLabelTag.userInteractionEnabled = YES;
    
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
    
    NSArray* arr = self.displayedNames;
    
    ANName* firstName = [arr firstObject];
    
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



#pragma mark - Helper Methods

- (void) checkUserDefaults {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL appAlreadySeen = [userDefaults boolForKey:kAppAlreadySeen];
    
    if (!appAlreadySeen) {
        
        ANPageViewController* pageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ANPageViewController"];
        
        [self presentViewController:pageVC animated:YES completion:nil];
        
    } else {
        
        NSInteger appLaunchesCount = [userDefaults integerForKey:kAppLaunchesCount];
        appLaunchesCount++;
        
        [userDefaults setInteger:appLaunchesCount forKey:kAppLaunchesCount];
        [userDefaults synchronize];
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


- (void) listenForGoingBackgroundNotification {
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    
    self.observer = [center addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if (self.presentedViewController != nil) {
            [self dismissViewControllerAnimated:false completion:nil];
        }
        
        
    }];
}

- (void) showActivityVCWithItems:(NSArray *)items {
    
    UIActivityViewController* activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    activityVC.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:activityVC animated:true completion:nil];
    
}





#pragma mark - Actions


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


- (void) showAlertShareErrorWithTitle:(NSString *)title andMessage:(NSString *) message {
    
    UIAlertController* errorAlertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [errorAlertController addAction:okAction];
    
    [self presentViewController:errorAlertController animated:true completion:nil];
    
    
}


- (IBAction)actionShareButtonPressed:(UIButton*)sender {
    
    ANName* firstName = [self.displayedNames objectAtIndex:0];
    
    NSString* introTextToShare = NSLocalizedString(@"SHARE_TEXT", nil);
    
    NSString* fullTextToShare = [NSString stringWithFormat:@"%@ - %@", firstName.firstName, introTextToShare];
    
    UIImage* imageToShare = [UIImage imageNamed:firstName.nameImageName];
    
    // Presenting action sheet with share options - Facebook, Twitter, UIActivityVC
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"SHARE_MESSAGE", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    
    // TWITTER ACTION
    UIAlertAction* twitterAction = [UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // Check if Twitter is available. Otherwise, display an error message
        
        if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            [self showAlertShareErrorWithTitle:NSLocalizedString(@"SHARE_TWITTER_UNAVAILABLE_TITLE", nil) andMessage:NSLocalizedString(@"SHARE_TWITTER_UNAVAILABLE_MESSAGE", nil)];
            
            return;
            
        }
        
        // Display Tweet Composer
        SLComposeViewController* tweetComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetComposer setInitialText:fullTextToShare];
        [tweetComposer addImage:imageToShare];
        
        //[tweetComposer addURL:shareUrl];
        
        [self presentViewController:tweetComposer animated:true completion:nil];
        
        
    }];
    
    // FACEBOOK ACTION
    UIAlertAction* facebookAction = [UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // Check if Facebook is available. Otherwise, display an error message
        
        if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            [self showAlertShareErrorWithTitle:NSLocalizedString(@"SHARE_FACEBOOK_UNAVAILABLE_TITLE", nil) andMessage:NSLocalizedString(@"SHARE_FACEBOOK_UNAVAILABLE_MESSAGE", nil)];
            
            return;
            
        }
        
        // Display Facebook Composer
        SLComposeViewController* facebookComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [facebookComposer setInitialText:fullTextToShare];
        [facebookComposer addImage:imageToShare];
        
        //[facebookComposer addURL:shareUrl];
        
        [self presentViewController:facebookComposer animated:true completion:nil];
        
    }];
    
    // OTHER ACTION - UIActivityVC
    UIAlertAction* otherAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"SHARE_ACTION_OTHER", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString* textToShare = firstName.firstName;
        
        NSArray* shareItems;
        
        if (imageToShare != nil) {
            shareItems = @[textToShare, imageToShare];
        } else {
            shareItems = @[textToShare];
        }
        
        [self showActivityVCWithItems:shareItems];
        
    }];
    
    // CANCEL ACTION
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"CANCEL_CLEAR", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:facebookAction];
    [alertController addAction:twitterAction];
    [alertController addAction:otherAction];
    [alertController addAction:cancelAction];
    
    alertController.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    
    
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



#pragma mark - Touches

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
            ANLog(@"out of bounds");
            
            if (self.settingsViewLeadingConstraint.constant > -100) {
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


#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showDescriptionVC"]) {
        
        UINavigationController *destinationNavVC = segue.destinationViewController;
        
        ANDescriptioinVC *destinationVC = (ANDescriptioinVC*) destinationNavVC.topViewController;
        
        destinationVC.namesArray = self.namesWithDescriptions;
        
        
        
        destinationNavVC.transitioningDelegate = self.rotateTransition;
        
        
        
    }
    
}


#pragma mark - Gestures

- (void) actionTapOnNameLabel:(UITapGestureRecognizer*) recognizer {
    
    ANLog(@"actionTapOnNameLabel");
    
    
    
    // *** If there're names in array of names with descriptions - initializate ANDescriptionVC and transfer names array to it.
    
    if (self.isDescriptionAvailable) {
        
        [self performSegueWithIdentifier:@"showDescriptionVC" sender:nil];
        
        /*
         ANDescriptioinVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ANDescriptioinVC"];
         
         vc.namesArray = self.namesWithDescriptions;
         
         UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
         
         nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
         
         
         
         
         //nav.transitioningDelegate = self.rotateTransition;
         
         [self presentViewController:nav animated:YES completion:nil];
         */
        
    }
    
}




- (void) actionTapOnCategoryLabel:(UITapGestureRecognizer*) recognizer {
    
    ANCategoryVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ANCategoryVC"];
    
    vc.categories = self.sharedNamesFactory.namesCategories;
    
    vc.selectedCategory = self.selectedCategory;
    
    vc.delegate = self;
    
    ANLog(@"selectedCategory = %@", vc.selectedCategory);
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}



- (void) actionTapOnWheelView:(UITapGestureRecognizer*) recognizer {
    ANLog(@"actionTapOnWheelView");
    
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



#pragma mark - +++ ANCategorySelectionDelegate +++

- (void) categoryDidSelect:(ANNameCategory*) category {
    
    self.selectedCategory = category;
    
    [self.bgImageView setImage:[UIImage imageNamed:self.selectedCategory.nameCategoryBackgroundImageName]];
    
    NSString* currentNamesLabel = [self getNamesStringForNamesCount:self.namesCount];
    
    self.nameResultLabel.text = currentNamesLabel;
    
    self.nameCategoryLabel.text = self.selectedCategory.nameCategoryTitle;
    
}





@end














