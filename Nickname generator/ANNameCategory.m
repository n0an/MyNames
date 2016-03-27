//
//  ANNameCategory.m
//  Nickname generator
//
//  Created by Anton Novoselov on 27/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANNameCategory.h"

@implementation ANNameCategory


- (instancetype)initWithCategoryTitle:(NSString*) title andCategoryImageName:(NSString*) categoryImageName
{
    self = [super init];
    if (self) {
        self.nameCategoryTitle = title;
        self.nameCategoryImageName = categoryImageName;
    }
    return self;
}



@end
