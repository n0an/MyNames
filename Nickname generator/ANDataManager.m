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
            NSLog(@"NAME: %@ %@", favoriteName.nameFirstName, favoriteName.nameID);
            
        } else if ([object isKindOfClass:[ANFavNameCategory class]]) {
            ANFavNameCategory* category = (ANFavNameCategory*) object;
            NSLog(@"CATEGORY: %@, Names: %lu", category.categoryType, [category.names count]);
            
        }
        else {
            NSLog(@"!!! UNKNOWN OBJECT !!!");
        }
        
    }
    
    NSLog(@"COUNT = %lu", (unsigned long)[array count]);
    
}

- (NSArray*) getAllObjectsForName:(NSString*) name {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:name
                inManagedObjectContext:self.managedObjectContext];
    
    request.entity = description;
    // request.resultType = NSDictionaryResultType; // Selecting type for NSDictionary of request
    
    
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
        NSLog(@"Mark for delete: %@", object);
        [self.managedObjectContext deleteObject:object]; // Marking in Context object to delete
    }
    [self.managedObjectContext save:nil]; // Saving context, and deleting marked objects
}



- (void) addOrGetCategory:(ANNameCategory*) category andAddName:(ANFavoriteName*) name {
    
    NSString* alias = category.alias;
    
    NSArray* addedFavNameCats = [self getAllObjectsForName:@"ANFavNameCategory"];
    
    // If there're categories already - check for coincidence
    BOOL isArrEmpty = [addedFavNameCats count] == 0;
    
    if (!isArrEmpty) {
        // If there's already added category with such alias - stop execution
        for (ANFavNameCategory* favNavCat in addedFavNameCats) {
            if ([favNavCat.categoryType isEqualToString:category.alias]) {
                [favNavCat addNamesObject:name];
                return;
            }
        }
    }
    
    // If categories array is not empty, or there's no such category - add it to DB
    
    ANFavNameCategory* newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"ANFavNameCategory" inManagedObjectContext:self.managedObjectContext];
    
    newCategory.categoryType = category.alias;
    [newCategory addNamesObject:name];
    
    
}




#pragma mark - Public Methods


- (void) addFavoriteName:(ANName*) name {
    
    ANNameCategory* category = name.nameCategory;
    
    ANFavoriteName* favoriteName = [NSEntityDescription insertNewObjectForEntityForName:@"ANFavoriteName" inManagedObjectContext:self.managedObjectContext];
    
    favoriteName.nameFirstName = name.firstName;
    favoriteName.nameID = name.nameID;
    favoriteName.nameGender = [NSNumber numberWithBool:name.nameGender];
    favoriteName.nameDescription = name.nameDescription;
    favoriteName.nameURL = name.nameURL;
    favoriteName.nameImageName = name.nameImageName;
    
    NSError* error = nil;
    
    [self addOrGetCategory:category andAddName:favoriteName];
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
}


- (void) showAllNames {
    NSLog(@"===== showAllNames =====");
    [self printArray:[self getAllObjectsForName:@"ANFavoriteName"]];
}


- (void) showAllNameCategories {
    NSLog(@"===== showAllNameCategories =====");
    [self printArray:[self getAllObjectsForName:@"ANFavNameCategory"]];
}


- (void) clearFavoriteNamesDB {
    [self deleteAllObjectsForName:@"ANFavoriteName"];

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
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    NSLog(@"saveContext");
    
}







@end














