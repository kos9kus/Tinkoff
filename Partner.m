//
//  Partners.m
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 26/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import "Partner.h"
#import "Item.h"
#import "KKCoreDataStack.h"

static NSString *kEntityName = @"Partner";

@implementation Partner

// Insert code here to add functionality to your managed object subclass

+ (instancetype)mapPartnerDictionary:(NSDictionary*)dicPartner intoContext:(NSManagedObjectContext*)moc {
    @try {
        NSMutableDictionary *validDictionary = [NSMutableDictionary dictionaryWithDictionary:dicPartner];
        validDictionary[@"isMomentary"] = @([validDictionary[@"isMomentary"] boolValue]);
        validDictionary[@"hasLocations"] = @([validDictionary[@"hasLocations"] boolValue]);
        validDictionary[@"idItem"] = validDictionary[@"id"];
        validDictionary[@"descriptionItem"] = validDictionary[@"description"];
        [validDictionary removeObjectsForKeys:@[@"id", @"description", @"moneyMax", @"moneyMin", @"pointType", @"limits", @"externalPartnerId", @"hasPreferentialDeposition"]];
        
        Partner *entity = [Partner findOrCreatePartner:validDictionary[@"idItem"] context:moc];
        
        [entity setValuesForKeysWithDictionary:[validDictionary copy]];
        return entity;
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        return nil;
    } @finally { }
}

+ (instancetype)findOrCreatePartner:(NSString*)nameId context:(NSManagedObjectContext*)moc {
    Partner *partner = [Partner findPartner:nameId context:moc];
    if (!partner) {
        return [NSEntityDescription insertNewObjectForEntityForName:kEntityName inManagedObjectContext:moc];
    }
    
    return partner;
}

+ (instancetype)findPartner:(NSString*)nameId context:(NSManagedObjectContext*)moc {
    Partner *partner = [Partner fetchRegisteredObjectInContext:moc predicate:[Partner createPredicate:nameId] ];
    if (!partner) {
        partner = [KKCoreDataStack fetchObjectInContext:moc request:[Partner createFetchRequest:nameId limit:1]].firstObject;
    }
    return partner;
}

#pragma mark -

+ (instancetype)fetchRegisteredObjectInContext:(NSManagedObjectContext*)moc predicate:(NSPredicate*)predicate {
    for (NSManagedObject *item in moc.registeredObjects) {
        if ([item isKindOfClass:[Partner class] ]) {
            Partner *partnerItem = (Partner*)item;
            if (!partnerItem.fault && [predicate evaluateWithObject:partnerItem]) {
                return partnerItem;
            }
        }
    }
    return nil;
}

+ (NSPredicate*)createPredicate:(NSString*)nameId {
    return [NSPredicate predicateWithFormat:@"%K like %@", kIdItem, nameId];
}

+ (NSFetchRequest*)createFetchRequest:(NSString*)nameId limit:(NSUInteger)limit {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kEntityName];
    fetchRequest.predicate = [Partner createPredicate:nameId];
    if (limit != NSNotFound) {
        fetchRequest.fetchLimit = limit;
    }
    
    return fetchRequest;
}

@end
