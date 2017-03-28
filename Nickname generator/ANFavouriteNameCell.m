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

@implementation ANFavouriteNameCell

- (void) configureCellForFavoriteName:(ANFavoriteName *) favoriteName descriptionAvailable:(BOOL) isDescriptionAvailable isEditingMode:(BOOL) isEditingMode {
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@", favoriteName.nameFirstName];
    
    NSString* genderImage = !favoriteName.nameGender.boolValue ? @"masc02" : @"fem02";
    
    self.genderImageView.image = [UIImage imageNamed:genderImage];
    
    NSString* adaptedCategory = [[ANNamesFactory sharedFactory] adoptToLocalizationString:favoriteName.nameCategoryTitle];
    
    self.nameCategoryLabel.text = adaptedCategory;
    
    UIImage* imageName = [UIImage imageNamed:favoriteName.nameImageName];
    
    if (!imageName) {
        self.nameImageView.image = [UIImage imageNamed:@"eye"];
        [self.nameImageView setContentMode:UIViewContentModeCenter];
        
    } else {
        self.nameImageView.image = [UIImage imageNamed:favoriteName.nameImageName];
        [self.nameImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    
    if (isDescriptionAvailable) {
        self.infoImageView.hidden = NO;
    } else {
        self.infoImageView.hidden = YES;
    }
    
    self.checkBoxImageView.hidden = !isEditingMode;
    self.infoImageView.hidden = isEditingMode;
    
}




@end







