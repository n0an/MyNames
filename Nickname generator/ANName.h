//
//  ANName.h
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - ENUMS
typedef enum {
    ANGenderAll = -1,
    ANGenderMasculine = 0,
    ANGenderFeminine = 1
} ANGender;

typedef enum {
    ANTolkienRaceAll = 0,
    ANTolkienRaceElves = 1,
    ANTolkienRaceMen = 2,
    ANTolkienRaceHobbits = 3,
    ANTolkienRaceDwarves = 4,
    ANTolkienRaceAinur = 5,
    ANTolkienRaceOrcs = 6,
    ANTolkienRaceEnts = 7,
    ANTolkienRaceDragons = 8
} ANTolkienRace;

typedef enum {
    ANGOTHouseAll = 0,
    ANGOTHouseStark = 1,
    ANGOTHouseTargaryen = 2,
    ANGOTHouseLannister = 3
} ANGOTHouse;


@class ANNameCategory;

@interface ANName : NSObject

#pragma mark - PROPERTIES
@property (strong, nonatomic) NSString* nameID;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) ANNameCategory* nameCategory;
@property (strong, nonatomic) NSString* nameDescription;
@property (strong, nonatomic) NSString* nameImageName;
@property (strong, nonatomic) NSString* nameURL;
@property (assign, nonatomic) ANGender  nameGender;

#pragma mark - PUBLIC METHODS
+ (ANName*) randomNameforCategory:(ANNameCategory*)category andGender:(ANGender) gender;
+ (ANName*) randomNameforCategory:(ANNameCategory*)category race:(ANTolkienRace)race andGender:(ANGender) gender;
+ (ANName*) getNameForID:(NSString*) nameID andCategory:(ANNameCategory*) nameCategory;
    
+ (NSString *) getTolkienRaceStringForRace:(ANTolkienRace) race;
+ (NSString *) adoptTolkienRaceForLocalizationForRace:(ANTolkienRace) race;
+ (NSString *) getGOTHouseStringForHouse:(ANGOTHouse) house;

- (NSString*) getRace;

#pragma mark - TESTING METHODS (PUBLIC)
+ (ANName *) constructFakeName;

@end


// NAME CATEGORY:
/**********************
 01.02.0.15 - Myth, Vedic, Masculine, 15th name in Plist
 
 XX.YY.Z.NN.RR
 
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
    07 - Celtic Myth
 
 Z - Gender:
    0 - Masculine
    1 - Feminine
 
 NN - Index of name in base:
    01, 02, 03 etc.
 
 RR - Race in selected category:
    01 - Elves
    02 - Men
    03 - Hobbits
    04 - Dwarves
    05 - Ainur
    06 - Orcs
    07 - Ents
    08 - Dragons

 
*/
