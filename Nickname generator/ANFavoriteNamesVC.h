//
//  ANFavoriteNamesVC.h
//  Nickname generator
//
//  Created by Anton Novoselov on 04/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANCoreDataVC.h"

@interface ANFavoriteNamesVC : ANCoreDataVC

#pragma mark - OUTLETS
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *genderButtonMasc;
@property (weak, nonatomic) IBOutlet UIButton *genderButtonFem;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewGenderMasc;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewGenderFem;

#pragma mark - ACTIONS
- (IBAction)actionGndrBtnPressed:(id)sender;

@end
