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

- (instancetype)initWithCategoryTitle:(NSString*) title andCategoryImageName:(NSString*) categoryImageName;

@end
