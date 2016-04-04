//
//  ANCoreDataVC.h
//  Nickname generator
//
//  Created by Anton Novoselov on 04/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ANCoreDataVC : UITableViewController


@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;


@end
