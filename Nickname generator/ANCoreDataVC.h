//
//  ANCoreDataVC.h
//  Nickname generator
//
//  Created by Anton Novoselov on 04/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ANCoreDataVC : UITableViewController <NSFetchedResultsControllerDelegate>

#pragma mark - PUBLIC PROPERTIES
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

#pragma mark - HELPER METHODS
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
