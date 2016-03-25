//
//  ANGreekMythNames.h
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANName.h"

@interface ANGreekMythNames : ANName

@property (strong, nonatomic) NSString* firstName;

+ (ANGreekMythNames*) randomNameforGender:(ANGender*) gender;


@end
