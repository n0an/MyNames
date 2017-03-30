//
//  ANFRImage.m
//  Nickname generator
//
//  Created by Anton Novoselov on 30/03/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

#import "ANFRImage.h"
#import <Firebase.h>
#import "ANFBStorageManager.h"

@implementation ANFRImage

+ (void) downloadImage {
    
    FIRStorageReference *bgRef = [[[ANFBStorageManager sharedManager] getReferenceForBackground] child:@"persianBG"];
    
    
    [bgRef dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        
        if (data) {
            
            UIImage* bgImage = [UIImage imageWithData:data];
            
            NSLog(@"bgImage = %@", bgImage);
            
        } else {
            NSLog(@"error occured - %@", error);
        }
        
    }];
    
    
}


@end
