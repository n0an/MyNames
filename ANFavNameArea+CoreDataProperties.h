//
//  ANFavNameArea+CoreDataProperties.h
//  Nickname generator
//
//  Created by Anton Novoselov on 04/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ANFavNameArea.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANFavNameArea (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *areaType;
@property (nullable, nonatomic, retain) NSSet<ANFavNameCategory *> *categories;

@end

@interface ANFavNameArea (CoreDataGeneratedAccessors)

- (void)addCategoriesObject:(ANFavNameCategory *)value;
- (void)removeCategoriesObject:(ANFavNameCategory *)value;
- (void)addCategories:(NSSet<ANFavNameCategory *> *)values;
- (void)removeCategories:(NSSet<ANFavNameCategory *> *)values;

@end

NS_ASSUME_NONNULL_END
