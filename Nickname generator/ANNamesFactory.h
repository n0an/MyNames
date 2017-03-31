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

+ (ANNamesFactory*) sharedFactory;

- (ANName*) getRandomNameForCategory:(ANNameCategory*) category andGender:(ANGender) gender;
- (ANName*) getNameForID:(NSString*) nameID;
- (NSString*) adoptToLocalizationString:(NSString*) string;
- (ANNameCategory*) getCategoryForID:(NSString*) categoryID;

@end
