//
//  Items.m
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 26/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import "Item.h"
#import "Partner.h"
#import "KKCoreDataStack.h"

@import CoreLocation;

static NSString* const kEntityName = @"Item";

@implementation Item

// Insert code here to add functionality to your managed object subclass

+ (instancetype)mapFromDictionary:(NSDictionary*)itemDic intoContext:(NSManagedObjectContext*)moc {
    
    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
    NSNumber *lat = [NSNumber numberWithDouble:[itemDic[@"location"][@"latitude"] doubleValue]];
    NSNumber *lng = [NSNumber numberWithDouble:[itemDic[@"location"][@"longitude"] doubleValue]];
    [newDic setObject:lat forKey:@"latitude"];
    [newDic setObject:lng forKey:@"longitude"];
    if (itemDic[@"externalId"]) {
        [newDic setObject:itemDic[@"externalId"] forKey:@"externalId"];
    }
    if (itemDic[@"fullAddress"]) {
        [newDic setObject:itemDic[@"fullAddress"] forKey:@"fullAddress"];
    }
    if ([itemDic objectForKey:@"partnerName"]) {
        [newDic setObject:itemDic[@"partnerName"] forKey:@"partnerName"];
    }
    
    KKPosition positionPoint = KKPositionMake([newDic[@"latitude"] doubleValue], [newDic[@"longitude"] doubleValue], 0);
    
    Item *entity = [self findOrCreateItem:positionPoint context:moc];
    if (!entity.partner && newDic[@"partnerName"]) {
        entity.partner = [Partner findOrCreatePartner:newDic[@"partnerName"] context:moc];
        
    }
    [entity setValuesForKeysWithDictionary:[newDic copy]];
    
    return entity;
}

+ (NSArray*)fetchEntitiesPartnerName:(NSString*)partnerName position:(KKPosition)position context:(NSManagedObjectContext*)moc {
    
    NSPredicate *predicate = createPredicateWIthRadius_2(position);
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kEntityName];
    fetchRequest.predicate = predicate;
    
    return [KKCoreDataStack fetchObjectInContext:moc request:fetchRequest];
}

+ (instancetype)findOrCreateItem:(KKPosition)position context:(NSManagedObjectContext*)moc {
    Item *item = [KKCoreDataStack fetchObjectInContext:moc request:[self createFetchRequest:position limit:1]].firstObject;
    if (!item) {
        return [NSEntityDescription insertNewObjectForEntityForName:kEntityName inManagedObjectContext:moc];
    }
    return item;
}

#pragma mark -

+ (NSPredicate*)createPredicate:(KKPosition)position {
    return [NSPredicate predicateWithFormat:@"%K == %lf AND %K == %lf", klatitude, position.latitude, klongitude, position.longitude];
}

+ (NSFetchRequest*)createFetchRequest:(KKPosition)position limit:(NSUInteger)limit {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kEntityName];
    fetchRequest.predicate = [self createPredicate:position];
    if (limit != NSNotFound) {
        fetchRequest.fetchLimit = limit;
    }
    
    return fetchRequest;
}


@end
