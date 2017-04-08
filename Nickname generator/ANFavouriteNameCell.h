//
//  ANFavouriteNameCell.h
//  Nickname generator
//
//  Created by Anton Novoselov on 15/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ANFavoriteName;

@interface ANFavouriteNameCell : UITableViewCell

#pragma mark - OUTLETS
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameRaceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nameImageView;
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImageView;

#pragma mark - HELPER METHODS
- (void) configureCellForFavoriteName:(ANFavoriteName *) favoriteName descriptionAvailable:(BOOL) isDescriptionAvailable isEditingMode:(BOOL) isEditingMode;

@end
