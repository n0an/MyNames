//
//  ANFavouriteNameCell.m
//  Nickname generator
//
//  Created by Anton Novoselov on 15/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANFavouriteNameCell.h"
#import "ANFavoriteName.h"
#import "ANNamesFactory.h"
#import "ANFBStorageManager.h"
#import <FirebaseStorage/FirebaseStorage.h>
#import "ANNameCategory.h"

@implementation ANFavouriteNameCell

#pragma mark - HELPER METHODS
- (void) configureCellForFavoriteName:(ANFavoriteName *) favoriteName descriptionAvailable:(BOOL) isDescriptionAvailable isEditingMode:(BOOL) isEditingMode {
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@", favoriteName.nameFirstName];
    
    NSString* genderImage = !favoriteName.nameGender.boolValue ? @"masc02" : @"fem02";
    self.genderImageView.image = [UIImage imageNamed:genderImage];
    
    NSString* adaptedCategory = [[ANNamesFactory sharedFactory] adoptToLocalizationString:favoriteName.nameCategoryTitle];
    self.nameCategoryLabel.text = adaptedCategory;
    

    [self setImageAndImageHeightForName:favoriteName];
    
    if (isEditingMode) {
        
        self.checkBoxImageView.hidden = NO;
        self.infoImageView.hidden = YES;
        
    } else {
        self.checkBoxImageView.hidden = YES;
        
        if (isDescriptionAvailable) {
            self.infoImageView.hidden = NO;
        } else {
            self.infoImageView.hidden = YES;
        }
    }
    
    
    
}


- (void) setImageAndImageHeightForName:(ANFavoriteName *) name {
    
    ANName *originName = [[ANNamesFactory sharedFactory] getNameForID:name.nameID];
    ANNameCategory *originCategory = [[ANNamesFactory sharedFactory] getCategoryForID:originName.nameCategory.nameCategoryID];
    
    NSString *race = [originName getRace];
    
    if (race) {
        self.nameRaceLabel.text = race;
        self.nameRaceLabel.hidden = NO;
    } else {
        self.nameRaceLabel.hidden = YES;
    }
    
    
    
    NSString *categoryAlias = originCategory.alias;
    
    NSString* pathName;
    
    if (name.nameGender.boolValue == ANGenderMasculine) {
        pathName = [categoryAlias stringByAppendingString:@"MascImages"];
    } else {
        pathName = [categoryAlias stringByAppendingString:@"FemImages"];
    }
    
    NSString *imageFileName = [NSString stringWithFormat:@"%@/%@", pathName, name.nameImageName];
    
    NSURL *imageFileURL = [[[ANFBStorageManager sharedManager] getDocumentsDirectory] URLByAppendingPathComponent:imageFileName];
    
    
    // *** DOWNLOAD FROM FIREBASE TO FILE AND STORE LOCALLY
    
    UIImage *nameImage = [UIImage imageWithContentsOfFile:[imageFileURL path]];
    
    if (!nameImage) {
        
        self.nameImageView.image = [UIImage imageNamed:@"eye"];
        [self.nameImageView setContentMode:UIViewContentModeCenter];
        
        
        FIRStorageReference *imageNameRef = [[ANFBStorageManager sharedManager] getReferenceForFileName:imageFileName];
        
        FIRStorageDownloadTask *downloadTask = [imageNameRef writeToFile:imageFileURL completion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"error occured = %@", error);
                
            } else {
                UIImage* nameImage = [UIImage imageWithContentsOfFile:[imageFileURL path]];
                [self.nameImageView setImage:nameImage];
                [self.nameImageView setContentMode:UIViewContentModeScaleAspectFit];

            }
        }];
        
    } else {
        
        self.nameImageView.image = nameImage;
        [self.nameImageView setContentMode:UIViewContentModeScaleAspectFit];
        
    }
    
    
}


@end







