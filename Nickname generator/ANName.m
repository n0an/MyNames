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
    
    NSString* pathName;
    
    if (gender == ANGenderMasculine) {
        pathName = [category.alias stringByAppendingString:@"Masc"];
        
    } else {
        pathName = [category.alias stringByAppendingString:@"Fem"];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:pathName ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray* namesArr = [dict allKeys];
    
    totalNames = [dict count];
    
    NSInteger randIndex = [self getRandomForCount:totalNames];
    
    NSString* tmpStr = [namesArr objectAtIndex:randIndex];
    NSString* randomName = tmpStr.lowercaseString.capitalizedString;
    
    NSDictionary* nameParams = [dict objectForKey:tmpStr];
    
    NSString* nameID = [nameParams objectForKey:@"nameID"];
    
    NSString* nameDesc = [nameParams objectForKey:@"nameDescription"];
    NSString* cleanedDesc = [self stringWithoutBrackets:nameDesc];
    
    NSString* nameURL = [nameParams objectForKey:@"nameURL"];
    NSString* nameImageName = [nameParams objectForKey:@"nameImageName"];
    
    name.firstName          = randomName;
    name.nameID             = nameID;
    name.nameDescription    = cleanedDesc;
    name.nameURL            = nameURL;
    name.nameImageName      = nameImageName;
    name.nameCategory       = category;
    
    return name;
    
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
