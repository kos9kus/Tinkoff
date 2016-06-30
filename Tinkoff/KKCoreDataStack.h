//
//  KKCoreDataStack.h
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 26/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface KKCoreDataStack : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *cdMainContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *cdBackGroundContext;

- (void)resetBackGroundContext;
- (void)saveContext;

+ (NSArray*)fetchObjectInContext:(NSManagedObjectContext*)moc request:(NSFetchRequest*)request;

@end
