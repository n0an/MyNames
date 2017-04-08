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
#import <FirebaseStorage/FirebaseStorage.h>
#import "ANFBStorageManager.h"

@interface ANDescriptioinVC ()

#pragma mark - PRIVATE PROPERTIES
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
    
    [self refreshLabels];
    
    if (self.selectedName.nameURL && ![self.selectedName.nameURL isEqualToString:@""]) {
        self.readMoreButton.hidden = NO;
    } else {
        self.readMoreButton.hidden = YES;
    }
    
    [self setImageAndImageHeight];
 
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close24"] style:UIBarButtonItemStylePlain target:self action:@selector(actionCancel:)];
    
    self.navigationItem.leftBarButtonItem = cancel;
    
    NSMutableArray* rightBarButtonItems = [NSMutableArray array];
    
    UIBarButtonItem* shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionShareButtonPressed:)];
    self.shareButton = shareButton;
    [rightBarButtonItems addObject:shareButton];
    
    self.navigationItem.rightBarButtonItems = rightBarButtonItems;
    
    
    self.likeNonSetImage = [UIImage imageNamed:@"like1"];
    self.likeSetImage = [UIImage imageNamed:@"like1set"];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isNameFavorite = [[ANDataManager sharedManager] isNameFavorite:self.selectedName];
    [self refreshLikeButton];
}

#pragma mark - HELPER METHODS
- (void) refreshLabels {
    self.firstNameLabel.text = self.selectedName.firstName;
    self.nameCategoryLabel.text = self.selectedName.nameCategory.nameCategoryTitle;

    self.descriptionTextView.text = self.selectedName.nameDescription;
    NSString* genderImage = !self.selectedName.nameGender ? @"masc02" : @"fem02";
    
    self.genderImageView.image = [UIImage imageNamed:genderImage];
    
    [self.firstNameLabel sizeToFit];
    [self.nameCategoryLabel sizeToFit];
    
    self.navigationItem.title = self.selectedName.firstName;
}

- (void) setImageAndImageHeight {

    NSString *categoryAlias = self.selectedName.nameCategory.alias;
    
    NSString* pathName;
    
    if (self.selectedName.nameGender == ANGenderMasculine) {
        pathName = [categoryAlias stringByAppendingString:@"MascImages"];
    } else {
        pathName = [categoryAlias stringByAppendingString:@"FemImages"];
    }
    
    NSString *imageFileName = [NSString stringWithFormat:@"%@/%@", pathName, self.selectedName.nameImageName];
    
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

- (void) actionShareButtonPressed:(UIBarButtonItem*) sender {
    UIImage* imageToShare = [UIImage imageNamed:self.selectedName.nameImageName];
    [self showShareMenuActionSheetWithText:self.selectedName.firstName Image:imageToShare andSourceForActivityVC:self.shareButton];
}


- (IBAction)actionlikeButtonPressed:(UIButton*)sender {
    // *** Saving choosen names to CoreData
    if (self.isNameFavorite) {
        [[ANDataManager sharedManager] deleteFavoriteName:self.selectedName];
    } else {
        [[ANDataManager sharedManager] addFavoriteName:self.selectedName];
    }
    
    self.isNameFavorite = !self.isNameFavorite;

    [self refreshLikeButton];
}
    
- (IBAction)actionWebButtonPressed:(UIButton*)sender {
    NSString *urlString = self.selectedName.nameURL;
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    if (url != nil) {
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
        [self presentViewController:safariVC animated:true completion:nil];
    }
}



@end


