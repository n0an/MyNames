//
//  ANNameCategory.h
//  Nickname generator
//
//  Created by Anton Novoselov on 27/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANNameCategory : NSObject

@property (strong, nonatomic) NSString* nameCategoryTitle;
@property (strong, nonatomic) NSString* nameCategoryImageName;
@property (strong, nonatomic) NSString* alias;
@property (strong, nonatomic) NSString* nameCategoryID;

- (instancetype)initWithCategoryID:(NSString*) nameCategoryID andCategoryTitle:(NSString*) title andCategoryImageName:(NSString*) categoryImageName andAlias:(NSString*) alias;

@end
