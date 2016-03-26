//
//  ANNamesFactory.h
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANName.h"



typedef enum {
    ANNamesCategoryGreekMythology,
    ANNamesCategoryHinduism,
    ANNamesCategoryRomanMythology


} ANNamesCategory;



@interface ANNamesFactory : NSObject

@property (strong, nonatomic) NSArray* namesCategories;

- (ANName*) getRandomNameForCategory:(ANNamesCategory) category andGender:(ANGender) gender;

+ (ANNamesFactory*) sharedFactory;


@end
