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

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (ANDataManager*) sharedManager;


#pragma mark - Public Methods

- (void) addFavoriteName:(ANName*) name;

- (void) deleteFavoriteName:(ANName*) name;

- (void) clearFavoriteNamesDB;

- (void) showAllNames;

- (BOOL) isNameFavorite:(ANName*) name;


@end
