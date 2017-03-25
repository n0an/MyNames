//
//  ANDataManager.m
//  Nickname generator
//
//  Created by Anton Novoselov on 04/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANDataManager.h"
#import "ANName.h"
#import "ANNameCategory.h"

#import "ANUtils.h"


@implementation ANDataManager


+ (ANDataManager*) sharedManager {
    
    static ANDataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ANDataManager alloc] init];
    });
    
    return manager;
}


#pragma mark - Private Methods

- (void) printArray:(NSArray*) array {
    
    for (id object in array) {
        
        if ([object isKindOfClass:[ANFavoriteName class]]) {
            ANFavoriteName* favoriteName = (ANFavoriteName*) object;
            ANLog(@"NAME: %@ %@", favoriteName.nameFirstName, favoriteName.nameID);
            
        } else {
            ANLog(@"!!! UNKNOWN OBJECT !!!");
        }
        
    }
    
    ANLog(@"TOTAL COUNT = %lu", (unsigned long)[array count]);
    
}

- (NSArray*) getAllObjectsForName:(NSString*) name {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:name
                inManagedObjectContext:self.managedObjectContext];
    
    request.entity = description;
    
    NSError* reqestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&reqestError];
    
    if (reqestError) {
        NSLog(@"requestError = %@", [reqestError localizedDescription]);
    }
    
    return resultArray;
}


- (NSArray*) getAllObjectsForName:(NSString*) name andSortUsingDescriptors:(NSArray*) descriptors {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:name
                inManagedObjectContext:self.managedObjectContext];
    
    request.entity = description;
    
    [request setSortDescriptors:descriptors];
    
    NSError* reqestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&reqestError];
    
    if (reqestError) {
        NSLog(@"requestError = %@", [reqestError localizedDescription]);
    }
    
    return resultArray;
}


- (void) deleteAllObjectsForName:(NSString*) name {
    NSArray* allObjects = [self getAllObjectsForName:name];
    
    for (id object in allObjects) {
        ANLog(@"Mark for delete: %@", object);
        [self.managedObjectContext deleteObject:object];
    }
    [self.managedObjectContext save:nil];
}




#pragma mark - Public Methods

- (void) addFavoriteName:(ANName*) name {
    
    // Checking for doubles. If there's such name in DB - return from method
    NSArray* addedNames = [self getAllObjectsForName:ANCDMFavoriteName];
    
    // If there're names already - check for coincidence
    BOOL isArrEmpty = [addedNames count] == 0;
    
    if (!isArrEmpty) {
        // If there's already added name with such nameID - stop execution
        for (ANFavoriteName* favName in addedNames) {
            if ([favName.nameID isEqualToString:name.nameID]) {
                return;
            }
        }
    }

    ANFavoriteName* favoriteName = [NSEntityDescription insertNewObjectForEntityForName:ANCDMFavoriteName inManagedObjectContext:self.managedObjectContext];
    
    favoriteName.nameFirstName = name.firstName;
    favoriteName.nameID = name.nameID;
    ANLog(@"favoriteName.nameGender = %@", [NSNumber numberWithBool:name.nameGender]);
    favoriteName.nameGender = [NSNumber numberWithBool:name.nameGender];
    favoriteName.nameDescription = name.nameDescription;
    favoriteName.nameURL = name.nameURL;
    favoriteName.nameImageName = name.nameImageName;
    
    favoriteName.nameCategoryTitle = name.nameCategory.nameCategoryTitle;
    
    NSError* error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
}



- (void) deleteFavoriteName:(ANName*) name {
    
    NSArray* addedNames = [self getAllObjectsForName:ANCDMFavoriteName];
    
    // If there're names already - check for coincidence
    BOOL isArrEmpty = [addedNames count] == 0;
    
    if (!isArrEmpty) {
        // If there's already added name with such nameID - stop execution
        for (ANFavoriteName* favName in addedNames) {
            if ([favName.nameID isEqualToString:name.nameID]) {
                [self.managedObjectContext deleteObject:favName];
                break;
            }
        }
    }
    
    [self.managedObjectContext save:nil]; // Saving context, and deleting marked objects

}





- (void) showAllNames {
    ANLog(@"===== showAllNames =====");
    [self printArray:[self getAllObjectsForName:ANCDMFavoriteName]];
}


- (void) clearFavoriteNamesDB {
    [self deleteAllObjectsForName:ANCDMFavoriteName];
    
}

- (BOOL) isNameFavorite:(ANName*) name {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:ANCDMFavoriteName
                inManagedObjectContext:self.managedObjectContext];
    
    request.entity = description;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"nameFirstName == %@", name.firstName];
    
    request.predicate = predicate;
    
    NSError* reqestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&reqestError];
    
    if (reqestError) {
        NSLog(@"requestError = %@", [reqestError localizedDescription]);
    }
    
    ANLog(@"[resultArray count] == %lu", (unsigned long)[resultArray count]);
    
    
    
    return [resultArray count];
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.antonnovoselov._1_CoreDataHomeworkSuperman" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            
            postNotificationFatalCoreDataError();
            
        }
    }
    ANLog(@"saveContext");
    
}







@end














