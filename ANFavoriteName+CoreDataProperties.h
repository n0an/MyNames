//
//  ANFavoriteName+CoreDataProperties.h
//  Nickname generator
//
//  Created by Anton Novoselov on 05/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ANFavoriteName.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANFavoriteName (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *nameDescription;
@property (nullable, nonatomic, retain) NSString *nameFirstName;
@property (nullable, nonatomic, retain) NSNumber *nameGender;
@property (nullable, nonatomic, retain) NSString *nameID;
@property (nullable, nonatomic, retain) NSString *nameImageName;
@property (nullable, nonatomic, retain) NSString *nameURL;
@property (nullable, nonatomic, retain) NSString *nameCategoryTitle;

@end

NS_ASSUME_NONNULL_END
