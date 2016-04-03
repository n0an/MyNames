//
//  ANRomanMythNames.m
//  Nickname generator
//
//  Created by Anton Novoselov on 03/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANRomanMythNames.h"
#import "ANUtils.h"

@implementation ANRomanMythNames

+ (ANRomanMythNames*) randomNameforGender:(ANGender) gender {
    
    ANRomanMythNames* name = [[ANRomanMythNames alloc] init];
    
    NSInteger totalNames;
    
    NSString* pathName;
    
    if (gender == ANGenderMasculine) {
        
        pathName = @"MythRomanMasc";
        
    } else {
        pathName = @"MythRomanFem";
        
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:pathName ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray* namesArr = [dict allKeys];
    
    totalNames = [dict count];
    
    NSInteger randIndex = [self getRandomForCount:totalNames];
    
    NSString* tmpStr = [namesArr objectAtIndex:randIndex];
    NSString* randomName = tmpStr.lowercaseString.capitalizedString;
    
    NSDictionary* nameParams = [dict objectForKey:tmpStr];
    
    NSString* nameDesc = [nameParams objectForKey:@"nameDescription"];
    NSString* cleanedDesc = [self stringWithoutBrackets:nameDesc];
    
    NSString* nameImageName = [nameParams objectForKey:@"nameImageName"];
    
    
    ANLog(@"name = %@", randomName);
    ANLog(@"Desc = %@", cleanedDesc);
    ANLog(@"nameImageName = %@", nameImageName);
    
    name.firstName = randomName;
    name.nameDescription = cleanedDesc;
    name.imageName = nameImageName;
    
    return name;
    
}



@end
