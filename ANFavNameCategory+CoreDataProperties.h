//
//  ANFavNameCategory+CoreDataProperties.h
//  Nickname generator
//
//  Created by Anton Novoselov on 04/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ANFavNameCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANFavNameCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *categoryType;
@property (nullable, nonatomic, retain) ANFavNameArea *area;
@property (nullable, nonatomic, retain) NSSet<ANFavoriteName *> *names;

@end

@interface ANFavNameCategory (CoreDataGeneratedAccessors)

- (void)addNamesObject:(ANFavoriteName *)value;
- (void)removeNamesObject:(ANFavoriteName *)value;
- (void)addNames:(NSSet<ANFavoriteName *> *)values;
- (void)removeNames:(NSSet<ANFavoriteName *> *)values;

@end

NS_ASSUME_NONNULL_END
