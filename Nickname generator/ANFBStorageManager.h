//
//  ANFBStorageManager.h
//  Nickname generator
//
//  Created by Anton Novoselov on 30/03/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase.h>

@interface ANFBStorageManager : NSObject

+ (ANFBStorageManager*) sharedManager;
- (FIRStorageReference *) getReferenceForBackground;

- (FIRStorageReference *) getReferenceForFileName:(NSString *) fileName;

@end
