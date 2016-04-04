//
//  ANDataManager.h
//  Nickname generator
//
//  Created by Anton Novoselov on 04/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ANDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (ANDataManager*) sharedManager;


#pragma mark - Public Methods

- (NSArray*) getAllObjectsForName:(NSString*) name;
- (NSArray*) getAllObjectsForName:(NSString*) name andSortUsingDescriptors:(NSArray*) descriptors;

- (void) addFavoriteNameWithID:(NSString*) nameID andFirstName:(NSString*) firstName andGender:(BOOL) nameGender andDescription:(NSString*) nameDescription andURL:(NSString*) nameURL andImage:(NSString*) nameImage;


@end
