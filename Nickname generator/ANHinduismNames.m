//
//  ANHinduismNames.m
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANHinduismNames.h"
#import "ANUtils.h"


@implementation ANHinduismNames


static NSString* masculineNames[] = {
    
    @"Aditya", @"Agni", @"Ananta", @"Anil", @"Aniruddha",
    @"Arjuna", @"Aruna", @"Bala", @"Baladeva", @"Bharata",

    @"Bhaskara", @"Bhima", @"Brahma", @"Brijesha", @"Chandra",
    @"Damodara", @"Devaraja", @"Dilipa", @"Dipaka", @"Drupada"
    
};

static NSString* feminineNames[] = {
    
    @"Aditi", @"Ananta", @"Arundhati", @"Bala", @"Bhumi",
    @"Chandra", @"Damayanti", @"Devi", @"Draupadi", @"Durga",
    
    @"Gauri", @"Indira", @"Indrani", @"Jaya", @"Jayanti",
    @"Kali", @"Kalyani", @"Kamala", @"Kanti", @"Kumari"
    
};


+ (ANHinduismNames*) randomNameforGender:(ANGender) gender {
    
    ANHinduismNames* name = [[ANHinduismNames alloc] init];
    
    NSInteger rand1000 = arc4random_uniform(2000);
    ANLog(@"%d", rand1000);
    
    NSInteger randomIndex = rand1000 / 100;
    ANLog(@"%d", randomIndex);
    
    
    if (gender == ANGenderMasculine) {
        name.firstName = masculineNames[randomIndex];
    } else {
        name.firstName = feminineNames[randomIndex];
    }
    
    name.nameCategory = @"HinduMyth";
    name.nameID = [NSString stringWithFormat:@"01.02.%d.%ld", gender,(long)randomIndex];
    
    return name;
    
}


@end
