//
//  ANNickName.h
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANNickName : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* secondName;
@property (strong, nonatomic) NSString* thirdName;



+ (ANNickName*) randomName;


@end
