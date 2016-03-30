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



+ (NSString *)stringWithoutBrackets:(NSString *)input{
    NSString *expression = @"\\[[\\w]+\\]";
    while ([input rangeOfString:expression options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location!=NSNotFound){
        input = [input stringByReplacingOccurrencesOfString:expression withString:@"" options:NSRegularExpressionSearch|NSCaseInsensitiveSearch range:NSMakeRange(0, [input length])];
    }
    return input;
}


@end
