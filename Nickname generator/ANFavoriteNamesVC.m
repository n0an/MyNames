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
    
    
    NSSortDescriptor* firstNameDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"nameFirstName" ascending:YES];
    
//    NSSortDescriptor* lastNameDescriptor =
//    [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    
    [fetchRequest setSortDescriptors:@[firstNameDescriptor]]; // SORTING USING FETCH
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ANFavoriteName* favoriteName = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", favoriteName.nameFirstName];
    cell.detailTextLabel.text = favoriteName.nameID;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ANLog(@"didSelectRowAtIndexPath: %ld", (long)indexPath.row);
    
    ANFavoriteName* name = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    ANLog(@"selected name = %@", name.nameFirstName);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}











@end
