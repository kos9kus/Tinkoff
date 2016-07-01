//
//  Partners+CoreDataProperties.h
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 26/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Partner.h"

NS_ASSUME_NONNULL_BEGIN

static NSString* const kIdItem = @"idItem";

@interface Partner (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *depositionDuration;
@property (nullable, nonatomic, retain) NSString *descriptionItem;
@property (nullable, nonatomic, retain) NSNumber *hasLocations;
@property (nullable, nonatomic, retain) NSString *idItem;
@property (nullable, nonatomic, retain) NSNumber *isMomentary;
@property (nullable, nonatomic, retain) NSString *limitations;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *picture;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSSet<Item *> *item;

@end

@interface Partner (CoreDataGeneratedAccessors)

- (void)addItemObject:(Item *)value;
- (void)removeItemObject:(Item *)value;
- (void)addItem:(NSSet<Item *> *)values;
- (void)removeItem:(NSSet<Item *> *)values;

@end

NS_ASSUME_NONNULL_END
