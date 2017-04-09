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
#import "UIViewController+ANAlerts.m"

@interface ANFavoriteNamesVC ()

#pragma mark - PRIVATE PROPERTIES
@property (strong, nonatomic) NSString* searchPredicateString;
@property (assign, nonatomic) ANGender selectedGender;
@property (strong, nonatomic) id rotateTransition;
@property (assign, nonatomic) BOOL isEditingMode;
@property (strong, nonatomic) NSMutableArray* selectedIndexPaths;
@property (weak, nonatomic) UIBarButtonItem *editButton;
@property (weak, nonatomic) UIBarButtonItem *deleteButton;

@end

@implementation ANFavoriteNamesVC
@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isEditingMode = false;
    self.selectedGender = ANGenderAll;
    self.rotateTransition = [[ANRotateTransitionAnimator alloc] init];
    self.selectedIndexPaths = [NSMutableArray array];
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BARBUTTON_EDIT", nil) style:UIBarButtonItemStylePlain target:self action:@selector(actionEdit:)];
    
    self.navigationItem.leftBarButtonItem = editButton;
    self.editButton = editButton;
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.editButton.enabled = ([self.fetchedResultsController.sections count] != 0);
}

#pragma mark - HELPER METHODS
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
        postNotificationFatalCoreDataError();
    }
}

- (BOOL) isDescriptionAvailable: (ANFavoriteName*) name {
    
    return name.nameDescription && ![name.nameDescription isEqualToString:@""];
}


#pragma mark - ACTIONS
- (void) actionDeleteSelectedNames:(id) sender {
    
    NSMutableArray* namesToDelete = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        ANFavoriteName* favoriteName = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [namesToDelete addObject:favoriteName];
    }
    
    [self.selectedIndexPaths removeAllObjects];
    self.deleteButton.enabled = NO;

    [[ANDataManager sharedManager] deleteObjects:namesToDelete];
}

- (void) actionEdit:(UIBarButtonItem*) sender {
    
    self.isEditingMode = !self.isEditingMode;
    
    if (self.isEditingMode) {

        UIBarButtonItem* deleteButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ROW_ACTION_DELETE", nil) style:UIBarButtonItemStylePlain target:self action:@selector(actionDeleteSelectedNames:)];
        
        self.deleteButton = deleteButton;
        self.deleteButton.enabled = NO;
        
        UIBarButtonItem *deleteAllButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(actionClear:)];
        
        [self.editButton setTitle:NSLocalizedString(@"BARBUTTON_DONE", nil)];
        [self.editButton setStyle:UIBarButtonItemStyleDone];
        
        [self.navigationItem setLeftBarButtonItems:@[self.editButton, deleteButton] animated:YES];
        [self.navigationItem setRightBarButtonItem:deleteAllButton];
        
    } else {
        [self.editButton setTitle:NSLocalizedString(@"BARBUTTON_EDIT", nil)];
        [self.editButton setStyle:UIBarButtonItemStylePlain];

        [self.selectedIndexPaths removeAllObjects];
        
        [self.navigationItem setLeftBarButtonItems:@[self.editButton] animated:YES];
        self.navigationItem.rightBarButtonItem = nil;
        
        self.editButton.enabled = ([self.fetchedResultsController.sections count] != 0);
    }
    
    [self.tableView reloadData];
}

- (void) actionClear:(UIBarButtonItem*) sender {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"TITLE_CLEAR", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"AFFIRM_CLEAR", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[ANDataManager sharedManager] clearFavoriteNamesDB];
        
        [self actionEdit:nil];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"CANCEL_CLEAR", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    alertController.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)actionGndrBtnPressed:(id)sender {
    
    UIImage* mascActiveImage    = [UIImage imageNamed:@"masc01"];
    UIImage* mascNonactiveImage = [UIImage imageNamed:@"masc02"];
    
    UIImage* femActiveImage     = [UIImage imageNamed:@"fem01"];
    UIImage* femNonactiveImage  = [UIImage imageNamed:@"fem02"];
    
    if ([sender isEqual:self.genderButtonMasc]) {
        
        if (self.selectedGender == ANGenderAll || self.selectedGender == ANGenderFeminine) {
            self.selectedGender = ANGenderMasculine;
            
            self.imgViewGenderMasc.image = mascActiveImage;
            self.imgViewGenderFem.image = femNonactiveImage;

        } else if (self.selectedGender == ANGenderMasculine) {
            self.selectedGender = ANGenderAll;
            
            self.imgViewGenderMasc.image = mascNonactiveImage;
            self.imgViewGenderFem.image = femNonactiveImage;
        }
        
    } else if ([sender isEqual:self.genderButtonFem]) {
        
        if (self.selectedGender == ANGenderAll || self.selectedGender == ANGenderMasculine) {
            self.selectedGender = ANGenderFeminine;
            
            self.imgViewGenderMasc.image = mascNonactiveImage;
            self.imgViewGenderFem.image = femActiveImage;
            
        } else if (self.selectedGender == ANGenderFeminine) {
            self.selectedGender = ANGenderAll;
            
            self.imgViewGenderMasc.image = mascNonactiveImage;
            self.imgViewGenderFem.image = femNonactiveImage;
        }
    }
    
    [self configureFetchResultsController];
    [self.tableView reloadData];
}

#pragma mark - NAVIGATION
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showDescriptionVC"]) {
        UINavigationController *destinationNavVC = segue.destinationViewController;
        ANDescriptioinVC *destinationVC = (ANDescriptioinVC*) destinationNavVC.topViewController;
        
        ANFavoriteName* selectedFavoriteName = sender;
        NSString* nameID = selectedFavoriteName.nameID;
        ANName* originName = [[ANNamesFactory sharedFactory] getNameForID:nameID];
        
        destinationVC.selectedName = originName;
        
        destinationNavVC.transitioningDelegate = self.rotateTransition;
    }
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
    NSString* adaptedCategory = [[ANNamesFactory sharedFactory] adoptToLocalizationString:sectionName];
    
    return adaptedCategory;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"FavoriteCell";
    
    ANFavoriteName* favoriteName = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    ANFavouriteNameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell configureCellForFavoriteName:favoriteName descriptionAvailable:[self isDescriptionAvailable:favoriteName] isEditingMode:self.isEditingMode];
    
    if (self.isEditingMode) {
        if ([self.selectedIndexPaths containsObject:indexPath]) {
            [cell.checkBoxImageView setImage:[UIImage imageNamed:@"box_set"]];
        } else {
            [cell.checkBoxImageView setImage:[UIImage imageNamed:@"box_empty"]];
        }

    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isEditingMode) {
        return YES;
        
    } else {
        ANFavoriteName* name = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if ([self isDescriptionAvailable:name]) {
            return YES;
        }
    }
    
    return NO;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ANFavouriteNameCell* selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.isEditingMode) {
        if ([self.selectedIndexPaths containsObject:indexPath]) {
            [self.selectedIndexPaths removeObject:indexPath];
            [selectedCell.checkBoxImageView setImage:[UIImage imageNamed:@"box_empty"]];
            
        } else {
            [self.selectedIndexPaths addObject:indexPath];
            [selectedCell.checkBoxImageView setImage:[UIImage imageNamed:@"box_set"]];
        }
        
        self.deleteButton.enabled = ([self.selectedIndexPaths count] != 0);
        
    } else {
        ANFavoriteName* name = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if ([self isDescriptionAvailable:name]) {
            [self performSegueWithIdentifier:@"showDescriptionVC" sender:name];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"ROW_ACTION_SHARE", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        ANFavoriteName* firstName = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        UIImage* imageToShare = [UIImage imageNamed:firstName.nameImageName];
        
        [self showShareMenuActionSheetWithText:firstName.nameFirstName Image:imageToShare andSourceForActivityVC:self.view];
        
        
        [tableView setEditing:NO animated:YES];
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
