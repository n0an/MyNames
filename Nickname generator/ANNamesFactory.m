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
                
        ANNameCategory* randomCategory = [[ANNameCategory alloc] initWithCategoryID:@"00.00" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0000", nil) andAlias:@"RandomCat"];

        ANNameCategory* area02cat01 = [[ANNameCategory alloc] initWithCategoryID:@"02.01" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0201", nil) andAlias:@"FictionDune"];
        
        ANNameCategory* area02cat02 = [[ANNameCategory alloc] initWithCategoryID:@"02.02" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0202", nil) andAlias:@"FictionTolkien"];

        ANNameCategory* area01cat01 = [[ANNameCategory alloc] initWithCategoryID:@"01.01" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0001", nil) andAlias:@"MythGreek"];
        
        ANNameCategory* area01cat02 = [[ANNameCategory alloc] initWithCategoryID:@"01.02" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0002", nil) andAlias:@"MythVedic"];
        
        ANNameCategory* area01cat03 = [[ANNameCategory alloc] initWithCategoryID:@"01.03" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0003", nil)  andAlias:@"MythRoman"];
        
        ANNameCategory* area01cat04 = [[ANNameCategory alloc] initWithCategoryID:@"01.04" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0004", nil)  andAlias:@"MythNorse"];
        
        ANNameCategory* area01cat05 = [[ANNameCategory alloc] initWithCategoryID:@"01.05" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0005", nil)  andAlias:@"MythEgypt"];
                
        ANNameCategory* area01cat06 = [[ANNameCategory alloc] initWithCategoryID:@"01.06" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0006", nil)  andAlias:@"MythPersian"];
        
        ANNameCategory* area01cat07 = [[ANNameCategory alloc] initWithCategoryID:@"01.07" andCategoryTitle:NSLocalizedString(@"NAMECATEGORY0007", nil) andAlias:@"MythCeltic"];
   
        sharedFactory.namesCategories = @[randomCategory, area02cat01, area02cat02, area01cat01, area01cat02, area01cat03, area01cat04, area01cat05, area01cat06, area01cat07];
    });
    
    return sharedFactory;
}

#pragma mark - PUBLIC METHODS
- (ANName*) getRandomNameForCategory:(ANNameCategory*) category andGender:(ANGender) gender {
    
    ANName* result;
    
    if ([category.nameCategoryID isEqualToString:@"00.00"]) {
        
        ANNameCategory *randomCategory = [self getRandomCategory];
        
        if ([randomCategory.nameCategoryID isEqualToString:@"02.02"]) {
            result = [self getRandomTolkienForRace:ANTolkienRaceAll andGender:gender];
            
        } else {
            result = [ANName randomNameforCategory:randomCategory andGender:gender];
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
    
    NSString* adoptedCategory;
    
    if ([string isEqualToString:@"Greek mythology"] || [string isEqualToString:@"Греческая мифология"]) {
        adoptedCategory = NSLocalizedString(@"NAMECATEGORY0001", nil);
    } else if ([string isEqualToString:@"Vedic mythology"] || [string isEqualToString:@"Ведическая мифология"]) {
        adoptedCategory = NSLocalizedString(@"NAMECATEGORY0002", nil);
    } else if ([string isEqualToString:@"Roman mythology"] || [string isEqualToString:@"Римская мифология"]) {
        adoptedCategory = NSLocalizedString(@"NAMECATEGORY0003", nil);
    } else if ([string isEqualToString:@"Norse mythology"] || [string isEqualToString:@"Скандинавская мифология"]) {
        adoptedCategory = NSLocalizedString(@"NAMECATEGORY0004", nil);
    } else if ([string isEqualToString:@"Egyptian mythology"] || [string isEqualToString:@"Египетская мифология"]) {
        adoptedCategory = NSLocalizedString(@"NAMECATEGORY0005", nil);
    } else if ([string isEqualToString:@"Persian mythology"] || [string isEqualToString:@"Персидская мифология"]) {
        adoptedCategory = NSLocalizedString(@"NAMECATEGORY0006", nil);
    } else if ([string isEqualToString:@"Celtic mythology"] || [string isEqualToString:@"Кельтская мифология"]) {
        adoptedCategory = NSLocalizedString(@"NAMECATEGORY0007", nil);
    } else if ([string isEqualToString:@"Dune"] || [string isEqualToString:@"Дюна"]) {
        adoptedCategory = NSLocalizedString(@"NAMECATEGORY0201", nil);
    } else if ([string isEqualToString:@"Tolkien"] || [string isEqualToString:@"Толкиен"]) {
        adoptedCategory = NSLocalizedString(@"NAMECATEGORY0202", nil);
    } else {
        adoptedCategory = @"";
    }
    
    return adoptedCategory;
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
