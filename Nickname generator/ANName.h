//
//  ANName.h
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {

    ANGenderMasculine = 0,
    ANGenderFeminine = 1
    
} ANGender;


@interface ANName : NSObject

@property (strong, nonatomic) NSString* nameID;

@property (strong, nonatomic) NSString* firstName;

@property (strong, nonatomic) NSString* nameCategory;

@property (strong, nonatomic) NSString* nameDescription;

@property (strong, nonatomic) NSString* imageName;




@end


// NAME CATEGORY:
/**********************
 01.02.0.15
 
 XX.YY.Z.NN
 
 XX - Area: Myth, Regular names, Ancient names, etc:
    01 - Myth
    02 - 
 
 YY - Category in Area. Greek Myth, Roman Myth, etc:
    01 - Greek Myth
    02 - Vedic Myth
 
 Z - Gender: 0 - Masculine, 1 - Feminine
 NN - Index of name in base
 
*/
