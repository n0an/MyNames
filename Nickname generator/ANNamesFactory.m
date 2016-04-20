//
//  ANNamesFactory.m
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANNamesFactory.h"

#import "ANNameCategory.h"


@implementation ANNamesFactory





+ (ANNamesFactory*) sharedFactory {
    
    static ANNamesFactory* sharedFactory = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFactory = [[ANNamesFactory alloc] init];
        
        ANNameCategory* area01cat01 = [[ANNameCategory alloc] initWithCategoryID:@"01.01" andCategoryTitle:@"Греческая мифология" andCategoryImageName:@"medusa-bronze" andCategoryBackgroundImageName:@"bg03" andAlias:@"MythGreek"];
        ANNameCategory* area01cat02 = [[ANNameCategory alloc] initWithCategoryID:@"01.02" andCategoryTitle:@"Ведическая мифология" andCategoryImageName:@"vedicBg21_1920" andCategoryBackgroundImageName:@"vedicBg10_2437" andAlias:@"MythVedic"];
        ANNameCategory* area01cat03 = [[ANNameCategory alloc] initWithCategoryID:@"01.03" andCategoryTitle:@"Римская мифология" andCategoryImageName:@"romanBg14_4592" andCategoryBackgroundImageName:@"romanBg07_7784" andAlias:@"MythRoman"];
   
        sharedFactory.namesCategories = @[area01cat01, area01cat02, area01cat03];
        
    });
    
    return sharedFactory;
    
}


- (ANNameCategory*) getCategoryForID:(NSString*) categoryID {

    ANNameCategory* resultCategory;
    
    for (ANNameCategory* category in self.namesCategories) {
        
        if ([category.nameCategoryID isEqualToString:categoryID]) {
            
            
            resultCategory = category;
            break;
        }
        
    }
    
    return resultCategory;
}


- (ANName*) getRandomNameForCategory:(ANNameCategory*) category andGender:(ANGender) gender {
    
    ANName* result;
    
    result = [ANName randomNameforCategory:category andGender:gender];
    
    return result;
}



- (ANName*) getNameForID:(NSString*) nameID {
    
    NSString* nameCategoryID = [nameID substringToIndex:5];
    
    ANNameCategory* category = [self getCategoryForID:nameCategoryID];

    ANName* result = [ANName getNameForID:nameID andCategory:category];

    return result;
    
}






@end
