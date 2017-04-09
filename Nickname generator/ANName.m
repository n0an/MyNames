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

#pragma mark - CONSTANTS
NSString* const kRaceTokienAll      = @"All";
NSString* const kRaceTokienElves    = @"Elves";
NSString* const kRaceTokienMen      = @"Men";
NSString* const kRaceTokienHobbits  = @"Hobbits";
NSString* const kRaceTokienDwarves  = @"Dwarves";
NSString* const kRaceTokienAinur    = @"Ainur";
NSString* const kRaceTokienOrcs     = @"Orcs";
NSString* const kRaceTokienEnts     = @"Ents";
NSString* const kRaceTokienDragons  = @"Dragons";


@implementation ANName

#pragma mark - PUBLIC METHODS
+ (ANName*) randomNameforCategory:(ANNameCategory*)category andGender:(ANGender) gender {
    ANName* name = [[ANName alloc] init];
    
    NSDictionary* dict = [self getNamesDictionaryforCategory:category andGender:gender];
    NSArray* namesArr = [dict allKeys];
    
    NSInteger totalNames = [dict count];
    NSInteger randIndex = [self getRandomForCount:totalNames];
    NSString* tmpStr = [namesArr objectAtIndex:randIndex];
    
    [self fillName:name withParams:dict andKey:tmpStr andCategory:category];
    
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
    
    [self fillName:name withParams:dict andKey:tmpStr andCategory:category];
    
    return name;
}


+ (ANName*) getNameForID:(NSString*) nameID andCategory:(ANNameCategory*) nameCategory {
    // 01.02.0.15 - EXAMPLE OF ID (Mythology, Vedic, Masc, id15)
    
    ANName* name = [[ANName alloc] init];
    
    NSArray* nameAttributes = [nameID componentsSeparatedByString:@"."];
    ANGender nameGender = (ANGender)[[nameAttributes objectAtIndex:2] integerValue];
    NSInteger nameIDInPList = [[nameAttributes objectAtIndex:3] integerValue];
    
    NSDictionary *dict;
    
    if ([nameCategory.nameCategoryID isEqualToString:@"02.02"]) {
        
        ANTolkienRace nameRace = (ANTolkienRace)[[nameAttributes objectAtIndex:4] integerValue];
        
        dict = [self getNamesDictionaryforCategory:nameCategory race:nameRace andGender:nameGender];
        
    } else {
        
        dict = [self getNamesDictionaryforCategory:nameCategory andGender:nameGender];
    }
    
    NSArray* namesArr = [dict allKeys];
    
    NSString* resultKey;
    
    for (NSString* tempNameKey in namesArr) {
        NSDictionary* value = [dict objectForKey:tempNameKey];
        
        NSString* tempNameID = [value objectForKey:@"nameID"];
        
        if ([tempNameID isEqualToString:nameID]) {
            resultKey = tempNameKey;
        }
    }
    
    [self fillName:name withParams:dict andKey:resultKey andCategory:nameCategory];
    return name;
}


+ (NSString *) adoptTolkienRaceForLocalizationForRace:(ANTolkienRace) race {
    
    NSString *result;
    
    switch (race) {
        case ANTolkienRaceMen:
            result = NSLocalizedString(@"NAMERACE020202", nil);
            break;
            
        case ANTolkienRaceElves:
            result = NSLocalizedString(@"NAMERACE020201", nil);
            break;
            
        case ANTolkienRaceHobbits:
            result = NSLocalizedString(@"NAMERACE020203", nil);
            break;
            
        case ANTolkienRaceDwarves:
            result = NSLocalizedString(@"NAMERACE020204", nil);
            break;
            
        case ANTolkienRaceAinur:
            result = NSLocalizedString(@"NAMERACE020205", nil);
            break;
            
        case ANTolkienRaceOrcs:
            result = NSLocalizedString(@"NAMERACE020206", nil);
            break;
            
        case ANTolkienRaceEnts:
            result = NSLocalizedString(@"NAMERACE020207", nil);
            break;
            
        case ANTolkienRaceDragons:
            result = NSLocalizedString(@"NAMERACE020208", nil);
            break;
            
        default:
            result = nil;
            break;
    }
    
    return result;
}


+ (NSString *) getTolkienRaceStringForRace:(ANTolkienRace) race {
    
    NSString *result;
    
    switch (race) {
        case ANTolkienRaceMen:
            result = kRaceTokienMen;
            break;
            
        case ANTolkienRaceElves:
            result = kRaceTokienElves;
            break;
            
        case ANTolkienRaceHobbits:
            result = kRaceTokienHobbits;
            break;
            
        case ANTolkienRaceDwarves:
            result = kRaceTokienDwarves;
            break;
            
        case ANTolkienRaceAinur:
            result = kRaceTokienAinur;
            break;
            
        case ANTolkienRaceOrcs:
            result = kRaceTokienOrcs;
            break;
            
        case ANTolkienRaceEnts:
            result = kRaceTokienEnts;
            break;
            
        case ANTolkienRaceDragons:
            result = kRaceTokienDragons;
            break;
            
        default:
            result = kRaceTokienAll;
            break;
    }
    
    return result;
}


- (NSString*) getRace {
    
    if ([self.nameCategory.nameCategoryID isEqualToString:@"02.02"]) {
        
        NSArray *components = [self.nameID componentsSeparatedByString:@"."];
        
        ANTolkienRace nameRace = (ANTolkienRace)[[components objectAtIndex:4] integerValue];
        
        return [ANName adoptTolkienRaceForLocalizationForRace:nameRace];
    }
    
    return nil;
}


#pragma mark - HELPER METHODS

// ==== PLAIN NAMES
+ (NSDictionary*) getNamesDictionaryforCategory:(ANNameCategory*)category andGender:(ANGender) gender {
    
    NSDictionary *resultDict;
    
    if (gender == ANGenderAll) {
        
        NSDictionary* dictMasc = [self getDictMascOrFemForCategory:category andGender:ANGenderMasculine];
        
        NSDictionary* dictFem = [self getDictMascOrFemForCategory:category andGender:ANGenderFeminine];

        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
        
        [tmpDict addEntriesFromDictionary:dictMasc];
        [tmpDict addEntriesFromDictionary:dictFem];
        
        resultDict = tmpDict;
    } else {
        resultDict = [self getDictMascOrFemForCategory:category andGender:gender];
    }
    
    return resultDict;
}

+ (NSDictionary *) getDictMascOrFemForCategory:(ANNameCategory*)category andGender:(ANGender) gender {
    
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



// ==== RACE NAMES

+ (NSDictionary*) getNamesDictionaryforCategory:(ANNameCategory*) category race:(ANTolkienRace) race andGender:(ANGender) gender {
    
    NSDictionary *resultDict;
    
    if (gender == ANGenderAll) {
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
        
        NSDictionary* dictMasc = [self getTolkienDictMascOrFemForCategory:category race:race andGender:ANGenderMasculine];
        
        [tmpDict addEntriesFromDictionary:dictMasc];
        
        if (race != ANTolkienRaceOrcs && race != ANTolkienRaceDragons) {
            
            NSDictionary* dictFem = [self getTolkienDictMascOrFemForCategory:category race:race andGender:ANGenderFeminine];
            
            
            [tmpDict addEntriesFromDictionary:dictFem];
        }
        
        resultDict = tmpDict;
        
    } else {
        resultDict = [self getTolkienDictMascOrFemForCategory:category race:race andGender:gender];
    }
    
    return resultDict;
    
}


+ (NSDictionary *) getTolkienDictMascOrFemForCategory:(ANNameCategory*)category race:(ANTolkienRace) race andGender:(ANGender) gender {
    
    NSString* pathName;
    
    //Example filename: FictionTolkienMascElves.plist
    
    if (gender == ANGenderMasculine) {
        pathName = [category.alias stringByAppendingString:@"Masc"];
    } else {
        pathName = [category.alias stringByAppendingString:@"Fem"];
    }
    
#warning don't neet to check for !=All
    if (race !=  ANTolkienRaceAll) {
        NSString *raceString = [self getTolkienRaceStringForRace:race];
        pathName = [pathName stringByAppendingString:raceString];
        
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
    
    NSString* pathNameElves = [pathName stringByAppendingString:kRaceTokienElves];
    NSString* pathNameMen = [pathName stringByAppendingString:kRaceTokienMen];
    NSString* pathNameHobbits = [pathName stringByAppendingString:kRaceTokienHobbits];
    NSString* pathNameDwarves = [pathName stringByAppendingString:kRaceTokienDwarves];
    NSString* pathNameAinur = [pathName stringByAppendingString:kRaceTokienAinur];
    NSString* pathNameOrcs = [pathName stringByAppendingString:kRaceTokienOrcs];
    NSString* pathNameEnts = [pathName stringByAppendingString:kRaceTokienEnts];
    NSString* pathNameDragons = [pathName stringByAppendingString:kRaceTokienDragons];
    
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
    
    
    NSString *pathEnts = [[NSBundle mainBundle] pathForResource:pathNameEnts ofType:@"plist"];
    NSDictionary *dictEnts = [NSDictionary dictionaryWithContentsOfFile:pathEnts];
    
    
    [allTolkienNamesDict addEntriesFromDictionary:dictElves];
    [allTolkienNamesDict addEntriesFromDictionary:dictMen];
    [allTolkienNamesDict addEntriesFromDictionary:dictHobbits];
    [allTolkienNamesDict addEntriesFromDictionary:dictDwarves];
    [allTolkienNamesDict addEntriesFromDictionary:dictAinur];
    [allTolkienNamesDict addEntriesFromDictionary:dictEnts];
    
    if (gender != ANGenderFeminine) {
        NSString *pathOrcs = [[NSBundle mainBundle] pathForResource:pathNameOrcs ofType:@"plist"];
        NSDictionary *dictOrcs = [NSDictionary dictionaryWithContentsOfFile:pathOrcs];
        
        NSString *pathDragons = [[NSBundle mainBundle] pathForResource:pathNameDragons ofType:@"plist"];
        NSDictionary *dictDragons = [NSDictionary dictionaryWithContentsOfFile:pathDragons];
        
        [allTolkienNamesDict addEntriesFromDictionary:dictOrcs];
        [allTolkienNamesDict addEntriesFromDictionary:dictDragons];

    }

    return allTolkienNamesDict;
}

+ (void) fillName:(ANName*)inputName withParams:(NSDictionary*) params andKey:(NSString*) key andCategory:(ANNameCategory*) category {
    
    NSString* firstNameStr;
    
    NSArray *nameComponents = [key componentsSeparatedByString:@" "];
    
    if ([nameComponents count] > 1) {
        
        firstNameStr = [self handleRomanNumbersForNameComponents:nameComponents];
        
    } else {
        firstNameStr = key.lowercaseString.capitalizedString;
    }
    
    NSDictionary* nameParams = [params objectForKey:key];
    NSString* nameID = [nameParams objectForKey:@"nameID"];
    
    // 02.02.0
    
    NSArray *nameIDComponents = [nameID componentsSeparatedByString:@"."];
    
    ANGender genderOfName = (ANGender)[nameIDComponents[2] integerValue];
    
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
    inputName.nameGender         = genderOfName;
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


+ (BOOL) findRomanNumberForComponent:(NSString *) component {
    NSArray *romanNumbers = @[@"II", @"III", @"IV", @"VI", @"VII", @"VIII", @"IX", @"XI", @"XII", @"XIII", @"XIV", @"XV", @"XVI", @"XVII", @"XVIII", @"XIX", @"XX"];
    
    for (NSString *romanNumber in romanNumbers) {
        if ([[component uppercaseString] isEqualToString:romanNumber]) {
            return YES;
        }
    }
    
    return NO;
}

+ (NSString *) handleRomanNumbersForNameComponents:(NSArray *) nameComponents {
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (int index = 1; index < [nameComponents count]; index++) {
        
        NSString *component = nameComponents[index];
        
        if ([component length] == 1) {
            [resultArray addObject:[component uppercaseString]];
            continue;
        }
        
        if ([self findRomanNumberForComponent:component]) {
            [resultArray addObject:[component uppercaseString]];
            
        } else {
            [resultArray addObject:[component capitalizedString]];
        }
    }
    
    NSString *firstComponent = [[nameComponents firstObject] capitalizedString];
    [resultArray insertObject:firstComponent atIndex:0];
    NSString *resultString = [resultArray componentsJoinedByString:@" "];
    
    return resultString;
}




@end








