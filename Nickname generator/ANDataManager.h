//
//  ANDataManager.h
//  Nickname generator
//
//  Created by Anton Novoselov on 04/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ANFavoriteName+CoreDataProperties.h"

@class ANName;

@interface ANDataManager : NSObject

#pragma mark - PUBLIC PROPERTIES
+ (ANDataManager*) sharedManager;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark - PUBLIC METHODS
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void) addFavoriteName:(ANName*) name;
- (void) deleteFavoriteName:(ANName*) name;

- (void) clearFavoriteNamesDB;
- (void) deleteObjects:(NSArray*) objects;

- (void) showAllNames;
- (BOOL) isNameFavorite:(ANName*) name;

@end
