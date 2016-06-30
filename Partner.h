//
//  Partners.h
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 26/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

NS_ASSUME_NONNULL_BEGIN

@interface Partner : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (instancetype)findOrCreatePartner:(NSString*)nameId context:(NSManagedObjectContext*)moc;

+ (instancetype)mapPartnerDictionary:(NSDictionary*)dicPartner intoContext:(NSManagedObjectContext*)moc;

@end

NS_ASSUME_NONNULL_END

#import "Partner+CoreDataProperties.h"
