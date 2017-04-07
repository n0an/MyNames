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

#pragma mark - SINGLETON
+ (ANNamesFactory*) sharedFactory {
    
    static ANNamesFactory* sharedFactory = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFactory = [[ANNamesFactory alloc] init];
        
        ANNameCategory* randomCategory = [[ANNameCategory alloc] initWithCategoryID:@"00.00" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0000", nil) andCategoryImageName:@"diceBG01_3840" andCategoryBackgroundImageName:@"diceBG03_1920" andAlias:@"RandomCat"];
        
        ANNameCategory* area02cat01 = [[ANNameCategory alloc] initWithCategoryID:@"02.01" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0201", nil) andCategoryImageName:@"fictionDuneBg01" andCategoryBackgroundImageName:@"fictionDuneBg02" andAlias:@"FictionDune"];
        
        ANNameCategory* area02cat02 = [[ANNameCategory alloc] initWithCategoryID:@"02.02" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0202", nil) andCategoryImageName:@"fictionDuneBg01" andCategoryBackgroundImageName:@"fictionDuneBg02" andAlias:@"FictionTolkien"];

        ANNameCategory* area01cat01 = [[ANNameCategory alloc] initWithCategoryID:@"01.01" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0001", nil) andCategoryImageName:@"medusa-bronze" andCategoryBackgroundImageName:@"bg03" andAlias:@"MythGreek"];
        
        ANNameCategory* area01cat02 = [[ANNameCategory alloc] initWithCategoryID:@"01.02" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0002", nil) andCategoryImageName:@"vedic_stripe" andCategoryBackgroundImageName:@"vedicBg21_1920" andAlias:@"MythVedic"];
        
        ANNameCategory* area01cat03 = [[ANNameCategory alloc] initWithCategoryID:@"01.03" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0003", nil) andCategoryImageName:@"romanBg14_4592" andCategoryBackgroundImageName:@"romanBg07_7784" andAlias:@"MythRoman"];
        
        ANNameCategory* area01cat04 = [[ANNameCategory alloc] initWithCategoryID:@"01.04" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0004", nil) andCategoryImageName:@"norseBG05_2329" andCategoryBackgroundImageName:@"norseBG07_1900" andAlias:@"MythNorse"];
        
        ANNameCategory* area01cat05 = [[ANNameCategory alloc] initWithCategoryID:@"01.05" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0005", nil) andCategoryImageName:@"egyptBG15_1923" andCategoryBackgroundImageName:@"egyptBG01_1936" andAlias:@"MythEgypt"];
                
        ANNameCategory* area01cat06 = [[ANNameCategory alloc] initWithCategoryID:@"01.06" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0006", nil) andCategoryImageName:@"persianBG05_3627" andCategoryBackgroundImageName:@"persianBG" andAlias:@"MythPersian"];

        
        ANNameCategory* area01cat07 = [[ANNameCategory alloc] initWithCategoryID:@"01.07" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0007", nil) andCategoryImageName:@"celticBG05_1990" andCategoryBackgroundImageName:@"celticBG06_1280" andAlias:@"MythCeltic"];
   
        sharedFactory.namesCategories = @[randomCategory, area02cat01, area01cat01, area01cat02, area02cat02, area01cat03, area01cat04, area01cat05, area01cat06, area01cat07];
    });
    
    return sharedFactory;
}

#pragma mark - PUBLIC METHODS
- (ANName*) getRandomNameForCategory:(ANNameCategory*) category andGender:(ANGender) gender {
    
    ANName* result;
    
    if ([category.nameCategoryID isEqualToString:@"00.00"]) {
        
        ANNameCategory *queryCategory = [self getRandomCategory];
        
        if ([queryCategory.nameCategoryID isEqualToString:@"02.02"]) {
            result = [self getRandomTolkienForRace:ANTolkienRaceAll andGender:gender];
            
        } else {
            result = [ANName randomNameforCategory:queryCategory andGender:gender];
        }
        
    } else {
        
        result = [ANName randomNameforCategory:category andGender:gender];
    }
    
    return result;
}



- (ANName*) getRandomTolkienForRace:(ANTolkienRace) race andGender:(ANGender) gender {
    
    ANNameCategory* tolkienCategory = [self getCategoryForID:@"02.02"];
    
    ANName* result = [ANName randomNameforCategory:tolkienCategory race:race andGender:gender];
    
    return result;
}




- (ANName*) getNameForID:(NSString*) nameID {
    NSString* nameCategoryID = [nameID substringToIndex:5];
    ANNameCategory* category = [self getCategoryForID:nameCategoryID];
    
    ANName* result = [ANName getNameForID:nameID andCategory:category];
    return result;
}

- (NSString*) adoptToLocalizationString:(NSString*) string {
    
    NSString* adaptedCategory;
    
    if ([string isEqualToString:@"Greek mythology"] || [string isEqualToString:@"Греческая мифология"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0001", nil);
    } else if ([string isEqualToString:@"Vedic mythology"] || [string isEqualToString:@"Ведическая мифология"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0002", nil);
    } else if ([string isEqualToString:@"Roman mythology"] || [string isEqualToString:@"Римская мифология"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0003", nil);
    } else if ([string isEqualToString:@"Norse mythology"] || [string isEqualToString:@"Скандинавская мифология"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0004", nil);
    } else if ([string isEqualToString:@"Egyptian mythology"] || [string isEqualToString:@"Египетская мифология"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0005", nil);
    } else if ([string isEqualToString:@"Persian mythology"] || [string isEqualToString:@"Персидская мифология"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0006", nil);
    } else if ([string isEqualToString:@"Celtic mythology"] || [string isEqualToString:@"Кельтская мифология"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0007", nil);
    } else if ([string isEqualToString:@"Dune"] || [string isEqualToString:@"Дюна"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0201", nil);
    } else if ([string isEqualToString:@"Tolkien"] || [string isEqualToString:@"Толкиен"]) {
        adaptedCategory = NSLocalizedString(@"NAMECATEGORY0202", nil);
    } else {
        adaptedCategory = @"";
    }
    
    return adaptedCategory;
}

#pragma mark - HELPER METHODS
- (ANNameCategory *) getRandomCategory {
    
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.namesCategories];
    [tmpArr removeObjectAtIndex:0];
    
    NSInteger categoriesCount = [tmpArr count];
    
    NSInteger randomInd = arc4random_uniform((uint32_t)categoriesCount);
    
    ANNameCategory* resultCategory = [tmpArr objectAtIndex:randomInd];
    
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



@end
