//
//  ANFBStorageManager.m
//  Nickname generator
//
//  Created by Anton Novoselov on 30/03/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

#import "ANFBStorageManager.h"
#import <Firebase.h>
#import <FirebaseStorage/FirebaseStorage.h>

@interface ANFBStorageManager ()

@property (strong, nonatomic) FIRStorageReference *rootStorageRef;

@end

@implementation ANFBStorageManager

NSString* const STORAGE_BACKGROUNDS = @"Backgrounds";

#pragma mark - SINGLETON
+ (ANFBStorageManager*) sharedManager {
    
    static ANFBStorageManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ANFBStorageManager alloc] init];
        
        FIRStorage *storage = [FIRStorage storage];
        
        FIRStorageReference *storageRef = [storage reference];
        
        manager.rootStorageRef = storageRef;
        
    });
    
    return manager;
}

- (FIRStorageReference *) getReferenceForBackground {
    return [self.rootStorageRef child:STORAGE_BACKGROUNDS];
}

- (FIRStorageReference *) getReferenceForFileName:(NSString *) fileName {
    return [self.rootStorageRef child:fileName];
}

@end
