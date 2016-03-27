//
//  ANName.m
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANName.h"
#import "ANUtils.h"

@implementation ANName

+ (NSInteger) getRandomForCount:(NSInteger) totalCount {
    
    NSInteger randBig = arc4random_uniform(totalCount*100);
    ANLog(@"%d", randBig);
    
    
    NSInteger randomIndex = randBig / 100;
    ANLog(@"%d", randomIndex);
    
    return randomIndex;
}



@end
