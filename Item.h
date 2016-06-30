//
//  Items.h
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 26/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KKPosition.h"

@class Partner;

NS_ASSUME_NONNULL_BEGIN

@interface Item : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+ (instancetype)mapFromDictionary:(NSDictionary*)itemDic intoContext:(NSManagedObjectContext*)moc;
+ (NSArray*)fetchEntitiesPartnerName:(NSString* _Nullable )partnerName position:(KKPosition)position context:(NSManagedObjectContext*)moc;

@end

NS_ASSUME_NONNULL_END

#import "Item+CoreDataProperties.h"
