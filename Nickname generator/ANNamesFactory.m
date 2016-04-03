//
//  ANNamesFactory.m
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANNamesFactory.h"

#import "ANGreekMythNames.h"

#import "ANVedicMythNames.h"

#import "ANRomanMythNames.h"

#import "ANNameCategory.h"




@implementation ANNamesFactory


- (ANName*) getRandomNameForCategory:(ANNamesCategory) category andGender:(ANGender) gender {
    
    ANName* result;
    
    switch (category) {
        case ANNamesCategoryGreekMythology:
            result = [ANGreekMythNames randomNameforGender:gender];
            break;
        
        case ANNamesCategoryVedicMythology:
            result = [ANVedicMythNames randomNameforGender:gender];
            break;
            
        case ANNamesCategoryRomanMythology:
            result = [ANRomanMythNames randomNameforGender:gender];

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
        
        
        ANNameCategory* area01cat01 = [[ANNameCategory alloc] initWithCategoryTitle:@"Greek Mythology" andCategoryImageName:@"greek_gods"];
        ANNameCategory* area01cat02 = [[ANNameCategory alloc] initWithCategoryTitle:@"Vedic Mythology" andCategoryImageName:nil];
        ANNameCategory* area01cat03 = [[ANNameCategory alloc] initWithCategoryTitle:@"Roman Mythology" andCategoryImageName:nil];
        

        sharedFactory.namesCategories = @[area01cat01, area01cat02, area01cat03];
        
    });
    
    return sharedFactory;
    
}





@end
