//
//  ANVedicMythNames.m
//  Nickname generator
//
//  Created by Anton Novoselov on 01/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANVedicMythNames.h"
#import "ANUtils.h"

@implementation ANVedicMythNames


+ (ANVedicMythNames*) randomNameforGender:(ANGender) gender {
    
    ANVedicMythNames* name = [[ANVedicMythNames alloc] init];
    
    NSInteger totalNames;
    
    NSString* pathName;
    
    if (gender == ANGenderMasculine) {
        
        pathName = @"MythVedicMasc";
        
    } else {
        pathName = @"MythVedicFem";
        
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
