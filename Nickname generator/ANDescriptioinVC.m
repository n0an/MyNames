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
#import <Social/Social.h>

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
    
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close32"] landscapeImagePhone:[UIImage imageNamed:@"close24"] style:UIBarButtonItemStylePlain target:self action:@selector(actionCancel:)];
    
    self.navigationItem.leftBarButtonItem = cancel;
    
    NSMutableArray* rightBarButtonItems = [NSMutableArray array];
    
    UIBarButtonItem* shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionShareButtonPressed:)];
    self.shareButton = shareButton;
    [rightBarButtonItems addObject:shareButton];
    
    if ([self.namesArray count] > 1) {
        UIBarButtonItem* fixedSpaceFirst = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        fixedSpaceFirst.width = 10;
        
        UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowDescRight32"] landscapeImagePhone:[UIImage imageNamed:@"arrowDescRight24"] style:UIBarButtonItemStylePlain target:self action:@selector(actionNextPressed:)];
        
        UIBarButtonItem* previousButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowDescLeft32"] landscapeImagePhone:[UIImage imageNamed:@"arrowDescLeft24"] style:UIBarButtonItemStylePlain target:self action:@selector(actionPreviousPressed:)];

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
    
    self.navigationItem.title = self.currentName.firstName;
}

- (void) setScrollViewContentSize {
    CGRect contentRect = CGRectZero;
    
    for (UIView *view in self.contenView.subviews) {
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
    
    if (self.isNameFavorite) {
        
        [self.likeButton setImage:self.likeSetImage forState:UIControlStateNormal];
        
    } else {
        
        [self.likeButton setImage:self.likeNonSetImage forState:UIControlStateNormal];
    }
    
}


- (void) showActivityVCWithItems:(NSArray *)items {
    
    UIActivityViewController* activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    activityVC.popoverPresentationController.barButtonItem = self.shareButton;
    
    [self presentViewController:activityVC animated:true completion:nil];
    
}

- (void) showAlertShareErrorWithTitle:(NSString *)title andMessage:(NSString *) message {
    
    UIAlertController* errorAlertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [errorAlertController addAction:okAction];
    
    [self presentViewController:errorAlertController animated:true completion:nil];
    
    
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

- (void) actionShareButtonPressed:(UIBarButtonItem*) sender {
    
    
    ANName* firstName = self.currentName;
    
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









