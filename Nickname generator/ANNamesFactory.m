//
//  ANNamesFactory.m
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANNamesFactory.h"

#import "ANGreekMythNames.h"
#import "ANHinduismNames.h"


@implementation ANNamesFactory


- (ANName*) getRandomNameForCategory:(ANNamesCategory) category andGender:(ANGender) gender {
    
    ANName* result;
    
    switch (category) {
        case ANNamesCategoryHinduism:
            result = [ANHinduismNames randomNameforGender:gender];
            break;
            
        case ANNamesCategoryGreekMythology:
            result = [ANGreekMythNames randomNameforGender:gender];
            break;
            
        case ANNamesCategoryRomanMythology:
            break;
            
        default:
            break;
    }
    
    
    
    return result;
}



+ (ANNamesFactory*) sharedFactory {
    
    static ANNamesFactory* sharedFactory = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFactory = [[ANNamesFactory alloc] init];
        
        sharedFactory.namesCategories = [NSArray arrayWithObjects:
                                            @"Greek Mythology",
                                            @"Hinduism",
                                            nil];
        
    });
    
    return sharedFactory;
    
}








@end
