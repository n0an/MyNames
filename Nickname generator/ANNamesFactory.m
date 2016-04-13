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


- (ANName*) getRandomNameForCategory:(ANNameCategory*) category andGender:(ANGender) gender {
    
    ANName* result;
    
    result = [ANName randomNameforCategory:category andGender:gender];
    
    return result;
}



+ (ANNamesFactory*) sharedFactory {
    
    static ANNamesFactory* sharedFactory = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFactory = [[ANNamesFactory alloc] init];
        
        ANNameCategory* area01cat01 = [[ANNameCategory alloc] initWithCategoryID:@"01.01" andCategoryTitle:@"Greek Mythology" andCategoryImageName:@"bg06" andCategoryBackgroundImageName:@"bg03" andAlias:@"MythGreek"];
        ANNameCategory* area01cat02 = [[ANNameCategory alloc] initWithCategoryID:@"01.02" andCategoryTitle:@"Vedic Mythology" andCategoryImageName:@"vedicBg21_1920" andCategoryBackgroundImageName:@"vedicBg10_2437" andAlias:@"MythVedic"];
        ANNameCategory* area01cat03 = [[ANNameCategory alloc] initWithCategoryID:@"01.03" andCategoryTitle:@"Roman Mythology" andCategoryImageName:@"romanBg14_4592" andCategoryBackgroundImageName:@"romanBg07_7784" andAlias:@"MythRoman"];
   
        sharedFactory.namesCategories = @[area01cat01, area01cat02, area01cat03];
        
    });
    
    return sharedFactory;
    
}





@end
