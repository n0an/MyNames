//
//  ANFavoriteNamesVC.m
//  Nickname generator
//
//  Created by Anton Novoselov on 04/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANFavoriteNamesVC.h"
#import "ANName.h"
#import "ANUtils.h"

#import "ANFavoriteName+CoreDataProperties.h"
#import "ANDataManager.h"

#import "ANFavouriteNameCell.h"

#import "ANDescriptioinVC.h"

#import "ANNamesFactory.h"

#import "ANNameCategory.h"

#import "ANRotateTransitionAnimator.h"

#import <Social/Social.h>

@interface ANFavoriteNamesVC ()

@property (strong, nonatomic) NSString* searchPredicateString;

@property (assign, nonatomic) ANGender selectedGender;
    
@property (strong, nonatomic) id rotateTransition;

@end

@implementation ANFavoriteNamesVC
@synthesize fetchedResultsController = _fetchedResultsController;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedGender = ANGenderAll;
    
    self.rotateTransition = [[ANRotateTransitionAnimator alloc] init];

    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit_2_32"] landscapeImagePhone:[UIImage imageNamed:@"edit_2_24"] style:UIBarButtonItemStylePlain target:self action:@selector(actionEdit:)];
    UIBarButtonItem* clearButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clear32"] landscapeImagePhone:[UIImage imageNamed:@"clear24"] style:UIBarButtonItemStylePlain target:self action:@selector(actionClear:)];

    self.navigationItem.leftBarButtonItem = editButton;
    self.navigationItem.rightBarButtonItem = clearButton;
    

    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
}



#pragma mark - Helper Methods

- (void) configureFetchResultsController {
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"ANFavoriteName"
                inManagedObjectContext:self.managedObjectContext];
    
    fetchRequest.entity = description;
    
    NSSortDescriptor* nameCategoryTitleDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"nameCategoryTitle" ascending:YES];
    
    
    NSSortDescriptor* firstNameDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"nameFirstName" ascending:YES];
    
    NSSortDescriptor* nameGenderDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"nameGender" ascending:YES];
    
    NSPredicate* predicate;
    
    
    if (self.selectedGender != ANGenderAll) {
        
        if (self.searchPredicateString && ![self.searchPredicateString isEqualToString:@""]) {
            predicate = [NSPredicate predicateWithFormat:@"nameFirstName contains[cd] %@ AND nameGender == %@", self.searchPredicateString, [NSNumber numberWithInteger:self.selectedGender]];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"nameGender == %@", [NSNumber numberWithInteger:self.selectedGender]];
        }
        
    } else {
        
        if (self.searchPredicateString && ![self.searchPredicateString isEqualToString:@""]) {
            predicate = [NSPredicate predicateWithFormat:@"nameFirstName contains[cd] %@", self.searchPredicateString];
        } else {
            predicate = nil;
        }
        
    }

    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    

    [fetchRequest setSortDescriptors:@[nameCategoryTitleDescriptor, firstNameDescriptor, nameGenderDescriptor]];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:@"nameCategoryTitle"
                                                   cacheName:nil];
    
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}


- (BOOL) isDescriptionAvailable: (ANFavoriteName*) name {
    
    return name.nameDescription && ![name.nameDescription isEqualToString:@""];
}


- (NSString*) adoptToLocalizationString:(NSString*) string {
    
    NSString* adaptedCategory;
    
    if ([string isEqualToString:@"Greek mythology"] || [string isEqualToString:@"Греческая мифология"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0001", nil);
    } else if ([string isEqualToString:@"Vedic mythology"] || [string isEqualToString:@"Ведическая мифология"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0002", nil);
    } else if ([string isEqualToString:@"Roman mythology"] || [string isEqualToString:@"Римская мифология"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0003", nil);
    } else if ([string isEqualToString:@"Norse mythology"] || [string isEqualToString:@"Скандинавская мифология"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0004", nil);
    } else if ([string isEqualToString:@"Egyptian mythology"] || [string isEqualToString:@"Египетская мифология"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0005", nil);
    } else if ([string isEqualToString:@"Persian mythology"] || [string isEqualToString:@"Персидская мифология"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0006", nil);
    } else if ([string isEqualToString:@"Celtic mythology"] || [string isEqualToString:@"Кельтская мифология"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0007", nil);
    } else {
        adaptedCategory = @"";
    }

    return adaptedCategory;
    
    
}




#pragma mark - Actions

- (void) actionEdit:(UIBarButtonItem*) sender {
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    
    UIBarButtonItem* editButton;
    
    if (self.tableView.editing) {
        editButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"affirm_3_32"] landscapeImagePhone:[UIImage imageNamed:@"affirm_3_24"] style:UIBarButtonItemStylePlain target:self action:@selector(actionEdit:)];

    } else {
        editButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit_2_32"] landscapeImagePhone:[UIImage imageNamed:@"edit_2_24"] style:UIBarButtonItemStylePlain target:self action:@selector(actionEdit:)];

    }
    
    
    [self.navigationItem setLeftBarButtonItem:editButton animated:YES];
    
}


- (void) actionClear:(UIBarButtonItem*) sender {
    

    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"TITLE_CLEAR", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"AFFIRM_CLEAR", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[ANDataManager sharedManager] clearFavoriteNamesDB];
        
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"CANCEL_CLEAR", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    alertController.popoverPresentationController.sourceView = self.view;
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (IBAction)actionGndrBtnPressed:(id)sender {
    
    UIImage* mascActiveImage = [UIImage imageNamed:@"masc01"];
    UIImage* mascNonactiveImage = [UIImage imageNamed:@"masc02"];
    
    UIImage* femActiveImage = [UIImage imageNamed:@"fem01"];
    UIImage* femNonactiveImage = [UIImage imageNamed:@"fem02"];
    
    
    if ([sender isEqual:self.genderButtonMasc]) {
        
        if (self.selectedGender == ANGenderAll || self.selectedGender == ANGenderFeminine) {
            
            NSLog(@"Masc selected");
            
            self.selectedGender = ANGenderMasculine;
            
            self.imgViewGenderMasc.image = mascActiveImage;
            self.imgViewGenderFem.image = femNonactiveImage;

        } else if (self.selectedGender == ANGenderMasculine) {
            
            NSLog(@"All selected");
            
            self.selectedGender = ANGenderAll;
            
            self.imgViewGenderMasc.image = mascNonactiveImage;
            self.imgViewGenderFem.image = femNonactiveImage;
        }
        
        
    } else if ([sender isEqual:self.genderButtonFem]) {
        
        if (self.selectedGender == ANGenderAll || self.selectedGender == ANGenderMasculine) {
            
            NSLog(@"Fem selected");
            
            self.selectedGender = ANGenderFeminine;
            
            self.imgViewGenderMasc.image = mascNonactiveImage;
            self.imgViewGenderFem.image = femActiveImage;
            
        } else if (self.selectedGender == ANGenderFeminine) {
            
            NSLog(@"All selected");
            
            self.selectedGender = ANGenderAll;
            
            self.imgViewGenderMasc.image = mascNonactiveImage;
            self.imgViewGenderFem.image = femNonactiveImage;
        }
        
        
    }
    
    [self configureFetchResultsController];
    [self.tableView reloadData];

    
    
}



#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    [self configureFetchResultsController];
    
    
    return _fetchedResultsController;
}


#pragma mark - UITableViewDataSource

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    NSString* sectionName = sectionInfo.name;
    
    NSString* adaptedCategory = [self adoptToLocalizationString:sectionName];
    
    return adaptedCategory;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"FavoriteCell";
    
    ANFavoriteName* favoriteName = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    ANFavouriteNameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", favoriteName.nameFirstName];
    
    NSString* genderImage = !favoriteName.nameGender.boolValue ? @"masc02" : @"fem02";
    
    cell.genderImageView.image = [UIImage imageNamed:genderImage];
    
    
    NSString* adaptedCategory = [self adoptToLocalizationString:favoriteName.nameCategoryTitle];
    

    cell.nameCategoryLabel.text = adaptedCategory;
    
    
    UIImage* imageName = [UIImage imageNamed:favoriteName.nameImageName];
    
    if (!imageName) {
        
        cell.nameImageView.image = [UIImage imageNamed:@"eye"];
        
        [cell.nameImageView setContentMode:UIViewContentModeCenter];
        

    } else {
        cell.nameImageView.image = [UIImage imageNamed:favoriteName.nameImageName];

        [cell.nameImageView setContentMode:UIViewContentModeScaleAspectFit];

    }
    
    if ([self isDescriptionAvailable:favoriteName]) {
        cell.infoImageView.hidden = NO;
    } else {
        cell.infoImageView.hidden = YES;
    }
    
    
    return cell;
}


#pragma mark - Navigation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showDescriptionVC"]) {
        
        UINavigationController *destinationNavVC = segue.destinationViewController;
        
        ANDescriptioinVC *destinationVC = (ANDescriptioinVC*) destinationNavVC.topViewController;
        
        ANFavoriteName* selectedFavoriteName = sender;
        
        NSString* nameID = selectedFavoriteName.nameID;
        
        ANName* originName = [[ANNamesFactory sharedFactory] getNameForID:nameID];
        
        destinationVC.namesArray = @[originName];
        
        
        destinationNavVC.transitioningDelegate = self.rotateTransition;

        
        
    }
    
}

- (void) showAlertShareErrorWithTitle:(NSString *)title andMessage:(NSString *) message {
    
    UIAlertController* errorAlertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [errorAlertController addAction:okAction];
    
    [self presentViewController:errorAlertController animated:true completion:nil];
    
    
}


- (void) showActivityVCWithItems:(NSArray *)items {
    
    UIActivityViewController* activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    activityVC.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:activityVC animated:true completion:nil];
    
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ANLog(@"didSelectRowAtIndexPath: %ld", (long)indexPath.row);
    
    ANFavoriteName* name = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    ANLog(@"selected name = %@", name.nameFirstName);
    
    if ([self isDescriptionAvailable:name]) {
        
        
        [self performSegueWithIdentifier:@"showDescriptionVC" sender:name];
        
        
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"ROW_ACTION_SHARE", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        ANFavoriteName* firstName = [self.fetchedResultsController objectAtIndexPath:indexPath];

        
        NSString* introTextToShare = NSLocalizedString(@"SHARE_TEXT", nil);
        
        NSString* fullTextToShare = [NSString stringWithFormat:@"%@ - %@", firstName.nameFirstName, introTextToShare];
        
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
            
            NSString* textToShare = firstName.nameFirstName;
            
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
        
       
        
    }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"ROW_ACTION_DELETE", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            postNotificationFatalCoreDataError();
        }
        
        
        
    }];
    
    shareAction.backgroundColor = RGBA(48, 173, 99, 255);
    deleteAction.backgroundColor = [UIColor redColor];
    
    return @[deleteAction, shareAction];
    
}





#pragma mark - UISearchBarDelegate


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    self.searchPredicateString = searchText;
    
    [self configureFetchResultsController];
    
    [self.tableView reloadData];
    
}




@end
