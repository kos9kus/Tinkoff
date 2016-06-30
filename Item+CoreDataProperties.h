//
//  Items+CoreDataProperties.h
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 26/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Item.h"

NS_ASSUME_NONNULL_BEGIN

static const NSString *klatitude = @"latitude";
static const NSString *klongitude = @"longitude";

@interface Item (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *externalId;
@property (nullable, nonatomic, retain) NSString *fullAddress;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSString *partnerName;
@property (nullable, nonatomic, retain) Partner *partner;

@end

NS_ASSUME_NONNULL_END
