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
    ANGOTHouseLannister = 3,
    ANGOTHouseOther = 4
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
 
 ## Conception for App model architecture
 
 #### XX.YY.Z.NN[.RR]
 
 .RR - optional
 
 #### Name ID keys general description:
 
 | Key            | Description                                    |
 | :------------- | :-------------                                 |
 | **XX**         | Area: Myth, Regular names, Ancient names, etc  |
 | **YY**         | Category of Area. Greek Myth, Roman Myth, etc  |
 | **Z**          | Gender: 0 - Masculine, 1 - Feminine            |
 | **NN**         | Index number of name in plist file             |
 | **RR**         | Race in selected category (if applicable)      |
 
 For example:
 > 01.02.0.15 = Myth, Vedic, Masculine, 15th name in Plist
 
 > 02.02.1.2.03 = Fiction, Tolkien, Feminine, 2nd name in Plist, Hobbits race
 
 #### Specific ID keys description:
 ##### Area
 | Area Key       | Description          |
 | :------------- | :-------------       |
 | **01**         | Mythological         |
 | **02**         | Fiction and Fantasy  |
 | **03**         | Ancient real names   |
 
 ##### Category of Area
 | Area Key       | Category Key     | Description      |
 | :------------- | :-------------   | ------           |
 | **01**         | **01**           | Mythological     |
 |                | **02**           | Vedic            |
 |                | **03**           | Roman            |
 |                | **04**           | Norse            |
 |                | **05**           | Egypt            |
 |                | **06**           | Persian          |
 |                | **07**           | Celtic           |
 | **02**         | **01**           | Dune             |
 |                | **02**           | Tolkien          |
 |                | **03**           | Game of Thrones  |
 
 ##### Races or house, or subcat, or etc.
 | Area Key       | Category Key   | Race Key | Description       |
 | :------------- | :------------- | ------   | -----             |
 | **02**         | **02**         | 01       | Elves             |
 |                |                | 02       | Men               |
 |                |                | 03       | Hobbits           |
 |                |                | 04       | Dwarves           |
 |                |                | 05       | Ainur             |
 |                |                | 06       | Orcs              |
 |                |                | 07       | Ents              |
 |                |                | 08       | Dragons           |
 |                | **03**         | 01       | Stark             |
 |                |                | 02       | Targaryen         |
 |                |                | 03       | Lannister         |
 |                |                | 04       | Other (not shown) |

*/
