//
//  ANNickName.m
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANNickName.h"
#import "ANUtils.h"

@implementation ANNickName

static NSString* names[] = {
    
    @"Acantha",
    @"Achilles",
    @"Achilles",
    @"Adonis",
    @"Adrastea",
    @"Adrasteia",
    @"Adrastos",
    @"Aegle",
    @"Aella",
    @"Aeolus"

};


+ (ANNickName*) randomName {
    
    ANNickName* name = [[ANNickName alloc] init];
    
    NSInteger rand1000 = arc4random_uniform(1000);
    ANLog(@"%d", rand1000);
    
    
    NSInteger randomIndex = rand1000 / 100;
    ANLog(@"%d", randomIndex);
    
    
    name.firstName = names[randomIndex];
    
    
    return name;
    
}


@end
