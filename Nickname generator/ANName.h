//
//  ANName.h
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    ANGenderAll = -1,
    ANGenderMasculine = 0,
    ANGenderFeminine = 1
    
} ANGender;

@class ANNameCategory;

@interface ANName : NSObject

@property (strong, nonatomic) NSString* nameID;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) ANNameCategory* nameCategory;
@property (strong, nonatomic) NSString* nameDescription;
@property (strong, nonatomic) NSString* nameImageName;
@property (strong, nonatomic) NSString* nameURL;
@property (assign, nonatomic) ANGender  nameGender;


+ (ANName*) randomNameforCategory:(ANNameCategory*)category andGender:(ANGender) gender;
+ (ANName*) getNameForID:(NSString*) nameID andCategory:(ANNameCategory*) nameCategory;


@end


// NAME CATEGORY:
/**********************
 01.02.0.15 - Myth, Vedic, Masculine, 15th name in Plist
 
 XX.YY.Z.NN
 
 XX - Area: Myth, Regular names, Ancient names, etc:
    01 - Myth
    02 - Fantasy and Fiction
    03 -
 
 YY - Category in Area. Greek Myth, Roman Myth, etc:
    01 - Greek Myth
    02 - Vedic Myth
    03 - Roman Myth
    04 - Norse Myth
    05 - Egypt Myth
    06 - Persian Myth
 
 Z - Gender:
    0 - Masculine
    1 - Feminine
 
 NN - Index of name in base
 
*/
