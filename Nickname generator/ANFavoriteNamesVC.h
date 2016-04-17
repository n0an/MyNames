//
//  ANFavoriteNamesVC.h
//  Nickname generator
//
//  Created by Anton Novoselov on 04/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANCoreDataVC.h"

@interface ANFavoriteNamesVC : ANCoreDataVC

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSelectionSegmetControl;

- (IBAction)actionResetButtonPressed:(UIBarButtonItem*)sender;

- (IBAction)actionGenderControlValueChanged:(UISegmentedControl*)sender;


@end
