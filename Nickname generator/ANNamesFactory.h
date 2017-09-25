//
//  ANNamesFactory.h
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANName.h"

@interface ANNamesFactory : NSObject

@property (strong, nonatomic) NSArray* namesCategories;

#pragma mark - SINGLETON
+ (ANNamesFactory*) sharedFactory;

#pragma mark - PUBLIC METHODS
- (ANName*) getRandomNameForCategory:(ANNameCategory*) category andGender:(ANGender) gender;
- (ANName*) getRandomTolkienForRace:(ANTolkienRace) race andGender:(ANGender) gender;
- (ANName*) getRandomGOTForHouse:(ANGOTHouse) race andGender:(ANGender) gender;

- (ANName*) getNameForID:(NSString*) nameID;
- (NSString*) adoptToLocalizationString:(NSString*) string;
- (ANNameCategory*) getCategoryForID:(NSString*) categoryID;

@end
