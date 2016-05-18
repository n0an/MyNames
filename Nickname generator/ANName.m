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

+ (ANName*) randomNameforCategory:(ANNameCategory*)category andGender:(ANGender) gender {
    
    ANName* name = [[ANName alloc] init];
    
    NSInteger totalNames;
    
    NSDictionary* dict = [self getNamesDictionaryforCategory:category andGender:gender];
    
    NSArray* namesArr = [dict allKeys];
    
    totalNames = [dict count];
    
    NSInteger randIndex = [self getRandomForCount:totalNames];
    
    NSString* tmpStr = [namesArr objectAtIndex:randIndex];
    
    [self fillName:name withParams:dict andKey:tmpStr andGender:gender andCategory:category];
    
    return name;
    
}


+ (ANName*) getNameForID:(NSString*) nameID andCategory:(ANNameCategory*) nameCategory {

    // 01.02.0.15 - EXAMPLE OF ID
    
    ANName* name = [[ANName alloc] init];

    NSArray* nameAttributes = [nameID componentsSeparatedByString:@"."];

    ANGender nameGender = (ANGender)[[nameAttributes objectAtIndex:2] integerValue];
    
    NSInteger nameIDInPList = [[nameAttributes objectAtIndex:3] integerValue];
    
    NSLog(@"nameIDInPList = %ld", (long)nameIDInPList);
    
    NSDictionary *dict = [self getNamesDictionaryforCategory:nameCategory andGender:nameGender];
    
    NSArray* namesArr = [dict allKeys];
    
    NSString* resultKey;
    
    for (NSString* tempNameKey in namesArr) {
        
        NSDictionary* value = [dict objectForKey:tempNameKey];
        
        NSString* tempNameID = [value objectForKey:@"nameID"];
        
        if ([tempNameID isEqualToString:nameID]) {
            
            ANLog(@"WE FOUND IT!!");
            
            resultKey = tempNameKey;
            
        }
        
    }
    
    [self fillName:name withParams:dict andKey:resultKey andGender:nameGender andCategory:nameCategory];

    return name;
    
}




#pragma mark - Helper Methods

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
    
    NSInteger randomIndex = arc4random() % totalCount;
    
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
