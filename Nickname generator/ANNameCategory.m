//
//  ANNameCategory.m
//  Nickname generator
//
//  Created by Anton Novoselov on 27/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANNameCategory.h"

@implementation ANNameCategory


- (instancetype)initWithCategoryID:(NSString*) nameCategoryID andCategoryTitle:(NSString*) title andCategoryImageName:(NSString*) categoryImageName andCategoryBackgroundImageName:(NSString*) nameCategoryBackgroundImageName andAlias:(NSString*) alias
{
    self = [super init];
    if (self) {
        self.nameCategoryID = nameCategoryID;
        self.nameCategoryTitle = title;
        self.nameCategoryImageName = categoryImageName;
        self.nameCategoryBackgroundImageName = nameCategoryBackgroundImageName;
        self.alias = alias;
    }
    return self;
}



@end
