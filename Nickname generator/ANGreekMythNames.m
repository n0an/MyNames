//
//  ANGreekMythNames.m
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANGreekMythNames.h"
#import "ANUtils.h"

@implementation ANGreekMythNames


+ (ANGreekMythNames*) randomNameforGender:(ANGender) gender {
    
    ANGreekMythNames* name = [[ANGreekMythNames alloc] init];
    
    NSInteger totalNames;
    
    NSString* pathName;
    
    if (gender == ANGenderMasculine) {
        
        pathName = @"MythGreekMasc";
        
    } else {
        pathName = @"MythGreekFem";

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
