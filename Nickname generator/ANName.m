//
//  ANName.m
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANName.h"
#import "ANUtils.h"

#import "ANNameCategory.h"

@implementation ANName

#pragma mark - PUBLIC METHODS
+ (ANName*) randomNameforCategory:(ANNameCategory*)category andGender:(ANGender) gender {
    ANName* name = [[ANName alloc] init];
    
    NSDictionary* dict = [self getNamesDictionaryforCategory:category andGender:gender];
    NSArray* namesArr = [dict allKeys];
    
    NSInteger totalNames = [dict count];
    NSInteger randIndex = [self getRandomForCount:totalNames];
    NSString* tmpStr = [namesArr objectAtIndex:randIndex];
    
    [self fillName:name withParams:dict andKey:tmpStr andGender:gender andCategory:category];
    
    return name;
}

+ (ANName*) randomNameforCategory:(ANNameCategory*)category race:(ANTolkienRace)race andGender:(ANGender) gender {
    ANName* name = [[ANName alloc] init];
    
    NSDictionary* dict;
    
    if (race == ANTolkienRaceAll) {
        dict = [self getAllTolkienNamesForGender:gender];
        
    } else {
        dict = [self getNamesDictionaryforCategory:category race:race andGender:gender];
    }
    
    NSArray* namesArr = [dict allKeys];
    
    NSInteger totalNames = [dict count];
    
    
    NSInteger randIndex = [self getRandomForCount:totalNames];
    NSString* tmpStr = [namesArr objectAtIndex:randIndex];
    
    [self fillName:name withParams:dict andKey:tmpStr andGender:gender andCategory:category];
    
    return name;
}




+ (ANName*) getNameForID:(NSString*) nameID andCategory:(ANNameCategory*) nameCategory {
    // 01.02.0.15 - EXAMPLE OF ID (Mythology, Vedic, Masc, id15)
    
    ANName* name = [[ANName alloc] init];
    
    NSArray* nameAttributes = [nameID componentsSeparatedByString:@"."];
    ANGender nameGender = (ANGender)[[nameAttributes objectAtIndex:2] integerValue];
    NSInteger nameIDInPList = [[nameAttributes objectAtIndex:3] integerValue];
    
    ANLog(@"nameIDInPList = %ld", (long)nameIDInPList);
    NSDictionary *dict = [self getNamesDictionaryforCategory:nameCategory andGender:nameGender];
    
    NSArray* namesArr = [dict allKeys];
    
    NSString* resultKey;
    
    for (NSString* tempNameKey in namesArr) {
        NSDictionary* value = [dict objectForKey:tempNameKey];
        
        NSString* tempNameID = [value objectForKey:@"nameID"];
        
        if ([tempNameID isEqualToString:nameID]) {
            resultKey = tempNameKey;
        }
    }
    
    [self fillName:name withParams:dict andKey:resultKey andGender:nameGender andCategory:nameCategory];
    return name;
}

#pragma mark - HELPER METHODS
+ (NSDictionary*) getNamesDictionaryforCategory:(ANNameCategory*)category andGender:(ANGender) gender {
    NSString* pathName;
    
    if (gender == ANGenderMasculine) {
        pathName = [category.alias stringByAppendingString:@"Masc"];
    } else {
        pathName = [category.alias stringByAppendingString:@"Fem"];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:pathName ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return dict;
}

+ (NSDictionary*) getNamesDictionaryforCategory:(ANNameCategory*) category race:(ANTolkienRace) race andGender:(ANGender) gender {
    
    NSString* pathName;
    
    //Example filename: FictionTolkienMascElves.plist
    
    if (gender == ANGenderMasculine) {
        pathName = [category.alias stringByAppendingString:@"Masc"];
    } else {
        pathName = [category.alias stringByAppendingString:@"Fem"];
    }
    
    switch (race) {
        case ANTolkienRaceMen:
            pathName = [pathName stringByAppendingString:@"Men"];
            break;
            
        case ANTolkienRaceElves:
            pathName = [pathName stringByAppendingString:@"Elves"];
            break;
            
        case ANTolkienRaceHobbits:
            pathName = [pathName stringByAppendingString:@"Hobbits"];
            break;
            
        case ANTolkienRaceDwarves:
            pathName = [pathName stringByAppendingString:@"Dwarves"];
            break;
            
        case ANTolkienRaceAinur:
            pathName = [pathName stringByAppendingString:@"Ainur"];
            break;
            
        case ANTolkienRaceOrcs:
            pathName = [pathName stringByAppendingString:@"Orcs"];
            break;
            
        case ANTolkienRaceEnts:
            pathName = [pathName stringByAppendingString:@"Ents"];
            break;
            
        case ANTolkienRaceDragons:
            pathName = [pathName stringByAppendingString:@"Dragons"];
            break;
            
        default:
            break;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:pathName ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return dict;
}

+ (NSDictionary *) getAllTolkienNamesForGender:(ANGender) gender {
    
    NSString* pathName;
    
    if (gender == ANGenderMasculine) {
        pathName = [@"FictionTolkien" stringByAppendingString:@"Masc"];
    } else {
        pathName = [@"FictionTolkien" stringByAppendingString:@"Fem"];
    }
    
    NSString* pathNameElves = [pathName stringByAppendingString:@"Elves"];
    NSString* pathNameMen = [pathName stringByAppendingString:@"Men"];
    NSString* pathNameHobbits = [pathName stringByAppendingString:@"Hobbits"];
    NSString* pathNameDwarves = [pathName stringByAppendingString:@"Dwarves"];
    NSString* pathNameAinur = [pathName stringByAppendingString:@"Ainur"];
    NSString* pathNameOrcs = [pathName stringByAppendingString:@"Orcs"];
    NSString* pathNameEnts = [pathName stringByAppendingString:@"Ents"];
    NSString* pathNameDragons = [pathName stringByAppendingString:@"Dragons"];
    
    NSMutableDictionary* allTolkienNamesDict = [NSMutableDictionary dictionary];
    
    NSString *pathElves = [[NSBundle mainBundle] pathForResource:pathNameElves ofType:@"plist"];
    NSDictionary *dictElves = [NSDictionary dictionaryWithContentsOfFile:pathElves];
    
    NSString *pathMen = [[NSBundle mainBundle] pathForResource:pathNameMen ofType:@"plist"];
    NSDictionary *dictMen = [NSDictionary dictionaryWithContentsOfFile:pathMen];
    
    NSString *pathHobbits = [[NSBundle mainBundle] pathForResource:pathNameHobbits ofType:@"plist"];
    NSDictionary *dictHobbits = [NSDictionary dictionaryWithContentsOfFile:pathHobbits];
    
    NSString *pathDwarves = [[NSBundle mainBundle] pathForResource:pathNameDwarves ofType:@"plist"];
    NSDictionary *dictDwarves = [NSDictionary dictionaryWithContentsOfFile:pathDwarves];
    
    NSString *pathAinur = [[NSBundle mainBundle] pathForResource:pathNameAinur ofType:@"plist"];
    NSDictionary *dictAinur = [NSDictionary dictionaryWithContentsOfFile:pathAinur];
    
    NSString *pathOrcs = [[NSBundle mainBundle] pathForResource:pathNameOrcs ofType:@"plist"];
    NSDictionary *dictOrcs = [NSDictionary dictionaryWithContentsOfFile:pathOrcs];
    
    NSString *pathEnts = [[NSBundle mainBundle] pathForResource:pathNameEnts ofType:@"plist"];
    NSDictionary *dictEnts = [NSDictionary dictionaryWithContentsOfFile:pathEnts];
    
    NSString *pathDragons = [[NSBundle mainBundle] pathForResource:pathNameDragons ofType:@"plist"];
    NSDictionary *dictDragons = [NSDictionary dictionaryWithContentsOfFile:pathDragons];
    
    [allTolkienNamesDict addEntriesFromDictionary:dictElves];
    [allTolkienNamesDict addEntriesFromDictionary:dictMen];
    [allTolkienNamesDict addEntriesFromDictionary:dictHobbits];
    [allTolkienNamesDict addEntriesFromDictionary:dictDwarves];
    [allTolkienNamesDict addEntriesFromDictionary:dictAinur];
    [allTolkienNamesDict addEntriesFromDictionary:dictOrcs];
    [allTolkienNamesDict addEntriesFromDictionary:dictEnts];
    [allTolkienNamesDict addEntriesFromDictionary:dictDragons];
    
    return allTolkienNamesDict;
}

+ (void) fillName:(ANName*)inputName withParams:(NSDictionary*) params andKey:(NSString*) key andGender:(ANGender) gender andCategory:(ANNameCategory*) category {
    
    NSString* firstNameStr = key.lowercaseString.capitalizedString;
    NSDictionary* nameParams = [params objectForKey:key];
    NSString* nameID = [nameParams objectForKey:@"nameID"];
    
    NSString* nameDesc = [nameParams objectForKey:@"nameDescription"];
    NSString* cleanedDesc = [self stringWithoutBrackets:nameDesc];
    
    NSString* nameURL = [nameParams objectForKey:@"nameURL"];
    NSString* nameImageName = [nameParams objectForKey:@"nameImageName"];
    
    inputName.firstName          = firstNameStr;
    inputName.nameID             = nameID;
    inputName.nameDescription    = cleanedDesc;
    inputName.nameURL            = nameURL;
    inputName.nameImageName      = nameImageName;
    inputName.nameCategory       = category;
    inputName.nameGender         = gender;
}

+ (NSInteger) getRandomForCount:(NSInteger) totalCount {
    NSInteger randomIndex = arc4random_uniform((uint32_t)totalCount);
    return randomIndex;
}

+ (NSString *)stringWithoutBrackets:(NSString *)input{
    NSString *expression = @"\\[[\\w]+\\]";
    while ([input rangeOfString:expression options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location!=NSNotFound){
        input = [input stringByReplacingOccurrencesOfString:expression withString:@"" options:NSRegularExpressionSearch|NSCaseInsensitiveSearch range:NSMakeRange(0, [input length])];
    }
    return input;
}


@end
