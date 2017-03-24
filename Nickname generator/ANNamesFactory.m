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
        
        ANNameCategory* randomCategory = [[ANNameCategory alloc] initWithCategoryID:@"00.00" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0000", nil) andCategoryImageName:@"diceBG01_3840" andCategoryBackgroundImageName:@"diceBG03_1920" andAlias:@"RandomCat"];
        
        ANNameCategory* area02cat01 = [[ANNameCategory alloc] initWithCategoryID:@"02.01" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0201", NIL) andCategoryImageName:@"fictionDuneBg01" andCategoryBackgroundImageName:@"fictionDuneBg02" andAlias:@"FictionDune"];

        ANNameCategory* area01cat01 = [[ANNameCategory alloc] initWithCategoryID:@"01.01" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0001", nil) andCategoryImageName:@"medusa-bronze" andCategoryBackgroundImageName:@"bg03" andAlias:@"MythGreek"];
        
        ANNameCategory* area01cat02 = [[ANNameCategory alloc] initWithCategoryID:@"01.02" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0002", nil) andCategoryImageName:@"vedicBg21_1920" andCategoryBackgroundImageName:@"vedicBg10_2437" andAlias:@"MythVedic"];
        
        ANNameCategory* area01cat03 = [[ANNameCategory alloc] initWithCategoryID:@"01.03" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0003", nil) andCategoryImageName:@"romanBg14_4592" andCategoryBackgroundImageName:@"romanBg07_7784" andAlias:@"MythRoman"];
        
        ANNameCategory* area01cat04 = [[ANNameCategory alloc] initWithCategoryID:@"01.04" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0004", nil) andCategoryImageName:@"norseBG05_2329" andCategoryBackgroundImageName:@"norseBG07_5713" andAlias:@"MythNorse"];
        
        ANNameCategory* area01cat05 = [[ANNameCategory alloc] initWithCategoryID:@"01.05" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0005", nil) andCategoryImageName:@"egyptBG15_1923" andCategoryBackgroundImageName:@"egyptBG01_1936" andAlias:@"MythEgypt"];
        
        ANNameCategory* area01cat06 = [[ANNameCategory alloc] initWithCategoryID:@"01.06" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0006", nil) andCategoryImageName:@"persianBG05_3627" andCategoryBackgroundImageName:@"persianBG03_5615" andAlias:@"MythPersian"];
        
        ANNameCategory* area01cat07 = [[ANNameCategory alloc] initWithCategoryID:@"01.07" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0007", nil) andCategoryImageName:@"celticBG05_1990" andCategoryBackgroundImageName:@"celticBG06_1280" andAlias:@"MythCeltic"];
   
        sharedFactory.namesCategories = @[randomCategory, area02cat01, area01cat01, area01cat02, area01cat03, area01cat04, area01cat05, area01cat06, area01cat07];
        
    });
    
    return sharedFactory;
    
}

- (ANNameCategory*) getRandomCategory {
    
    ANNameCategory* resultCategory;
    
    NSMutableArray* tmpArr = [NSMutableArray arrayWithArray:self.namesCategories];
    [tmpArr removeObjectAtIndex:0];
    
    NSInteger categoriesCount = [tmpArr count];
    
    NSInteger randomInd = arc4random_uniform((unsigned int)categoriesCount * 1000) / 1000;
    
    resultCategory = [tmpArr objectAtIndex:randomInd];
    
    return resultCategory;
    
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
    ANNameCategory* queryCategory;
    
    if ([category.nameCategoryID isEqualToString:@"00.00"]) {
        queryCategory = [self getRandomCategory];
        
    } else {
        queryCategory = category;
    }
    
    result = [ANName randomNameforCategory:queryCategory andGender:gender];
    
    return result;
}



- (ANName*) getNameForID:(NSString*) nameID {
    
    NSString* nameCategoryID = [nameID substringToIndex:5];
    
    ANNameCategory* category = [self getCategoryForID:nameCategoryID];

    ANName* result = [ANName getNameForID:nameID andCategory:category];

    return result;
    
}






@end
