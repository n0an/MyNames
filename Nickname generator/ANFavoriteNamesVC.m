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


@interface ANFavoriteNamesVC ()

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
    
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

    self.navigationController.hidesBarsOnSwipe = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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



#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
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
    
    
    [fetchRequest setSortDescriptors:@[nameCategoryTitleDescriptor, firstNameDescriptor, nameGenderDescriptor]]; // SORTING USING FETCH
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:@"nameCategoryTitle"
                                                   cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
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
    
    
    return cell;
}





#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ANLog(@"didSelectRowAtIndexPath: %ld", (long)indexPath.row);
    
    ANFavoriteName* name = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    ANLog(@"selected name = %@", name.nameFirstName);
    
    
    if (name.nameDescription && ![name.nameDescription isEqualToString:@""]) {
        
        ANDescriptioinVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ANDescriptioinVC"];
        
        vc.namesArray = @[name];
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
    
    
    
    
    [self.tableView reloadData];
    
}








@end
