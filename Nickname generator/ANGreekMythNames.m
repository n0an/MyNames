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

static NSString* masculineNames[] = {
    
    @"Achilles", @"Achilles", @"Adonis", @"Adrastos", @"Aeolus",
    @"Aeson", @"Agamemnon", @"Aias", @"Aineias", @"Aiolos",
    
    @"Ajax", @"Alcides", @"Alexander", @"Alexandros", @"Alkeides",
    @"Apollo", @"Apollon", @"Ares", @"Argus", @"Aristaeus"

};

static NSString* feminineNames[] = {
    
    @"Acantha", @"Adrastea", @"Adrasteia", @"Aegle", @"Aella",
    @"Agaue", @"Aglaea", @"Aglaia", @"Aigle", @"Akantha",
    
    @"Alcippe", @"Alcyone", @"Alecto", @"Alekto", @"Alexandra",
    @"Alkippe", @"Alkyone", @"Ares", @"Althea", @"Amalthea"
    
};


+ (ANGreekMythNames*) randomNameforGender:(ANGender*) gender {
    
    ANGreekMythNames* name = [[ANGreekMythNames alloc] init];
    
    NSInteger rand1000 = arc4random_uniform(2000);
    ANLog(@"%d", rand1000);
    
    
    NSInteger randomIndex = rand1000 / 100;
    ANLog(@"%d", randomIndex);
    
    if (gender == ANGenderMasculine) {
        name.firstName = masculineNames[randomIndex];
    } else {
        name.firstName = feminineNames[randomIndex];
    }
    
    
    return name;
    
}













@end
