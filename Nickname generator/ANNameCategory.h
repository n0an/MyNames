//
//  ANNameCategory.h
//  Nickname generator
//
//  Created by Anton Novoselov on 27/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANNameCategory : NSObject

#pragma mark - PROPERTIES
@property (strong, nonatomic) NSString* nameCategoryTitle;
@property (strong, nonatomic) NSString* nameCategoryImageName;
@property (strong, nonatomic) NSString* nameCategoryBackgroundImageName;
@property (strong, nonatomic) NSString* alias;
@property (strong, nonatomic) NSString* nameCategoryID;

#pragma mark - INITIALIZER
- (instancetype)initWithCategoryID:(NSString*) nameCategoryID andCategoryTitle:(NSString*) title andAlias:(NSString*) alias;

@end
