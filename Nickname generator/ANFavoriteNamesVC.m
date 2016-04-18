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


@interface ANFavoriteNamesVC ()

@property (strong, nonatomic) NSString* searchPredicateString;

@property (assign, nonatomic) ANGender selectedGender;

@end

@implementation ANFavoriteNamesVC
@synthesize fetchedResultsController = _fetchedResultsController;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                   target:self
                                   action:@selector(actionEdit:)];
    
    self.navigationItem.leftBarButtonItem = editButton;
    
    
    // !!!IMPORTANT!!!
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

//    UIColor *separatorColor = RGBA(10, 10, 10, 255);
//
//    [self.tableView setSeparatorColor:separatorColor];
    
    self.selectedGender = ANGenderAll;
    
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // !!!IMPORTANT!!!
//    self.navigationController.hidesBarsOnSwipe = YES;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
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




#pragma mark - Actions

- (void) actionEdit:(UIBarButtonItem*) sender {
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing) {
        item = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:item
                                   target:self
                                   action:@selector(actionEdit:)];
    
    [self.navigationItem setLeftBarButtonItem:editButton animated:YES];
    
}




- (IBAction)actionResetButtonPressed:(UIBarButtonItem*)sender {
    
    [[ANDataManager sharedManager] clearFavoriteNamesDB];
    
    NSLog(@"\n********* AFTER DELETE *************");
    [[ANDataManager sharedManager] showAllNames];
    
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
    return [sectionInfo name];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"FavoriteCell";
    
    ANFavoriteName* favoriteName = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    ANFavouriteNameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", favoriteName.nameFirstName];
    cell.genderLabel.text = !favoriteName.nameGender.boolValue ? @"Masculine" : @"Feminine";
    cell.nameCategoryLabel.text = favoriteName.nameCategoryTitle;
    
    
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






#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ANLog(@"didSelectRowAtIndexPath: %ld", (long)indexPath.row);
    
    ANFavoriteName* name = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    ANLog(@"selected name = %@", name.nameFirstName);
    
    if ([self isDescriptionAvailable:name]) {
        
        ANDescriptioinVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ANDescriptioinVC"];
        
        NSString* nameID = name.nameID;
        
        NSString* nameCategoryID = [nameID substringToIndex:5];
        
        ANNameCategory* category = [[ANNamesFactory sharedFactory] getCategoryForID:nameCategoryID];
        
        
        ANName* originName = [[ANName alloc] init];
        
        originName.firstName        = name.nameFirstName;
        originName.nameID           = name.nameID;
        originName.nameGender       = name.nameGender.boolValue;
        originName.nameURL          = name.nameURL;
        
        originName.nameDescription  = name.nameDescription;
        originName.nameImageName    = name.nameImageName;
        
        originName.nameCategory     = category;

        
        vc.namesArray = @[originName];
        vc.isCustomNavigationBar = YES;
        
//        [self.navigationController pushViewController:vc animated:YES];
        
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    NSLog(@"textDidChange searchText = %@", searchText);
    
    self.searchPredicateString = searchText;
    
    [self configureFetchResultsController];
    
    
    [self.tableView reloadData];
    
    
}









@end
