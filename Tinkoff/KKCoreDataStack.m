//
//  KKCoreDataStack.m
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 26/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import "KKCoreDataStack.h"

@interface KKCoreDataStack()

@property (nonatomic, strong) NSPersistentStoreCoordinator *psd;

@end

@implementation KKCoreDataStack

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createPSD];
        _cdMainContext = [self createManagedObjectContext:NSMainQueueConcurrencyType];
        _cdBackGroundContext = [self createManagedObjectContext:NSPrivateQueueConcurrencyType];
    }
    return self;
}

#pragma mark -

- (void)resetBackGroundContext {
    [self.cdBackGroundContext performBlockAndWait:^{
        [self.cdBackGroundContext reset];
    }];
}

- (void)saveContext {
    [self.cdBackGroundContext performBlockAndWait:^{
        NSError *error;
        if ([self.cdBackGroundContext hasChanges]) {
            [self.cdBackGroundContext save:&error];
        }
        if (error) {
            NSLog(@"%@", error.description);
            [self.cdBackGroundContext rollback];
        }
    }];
}

#pragma mark - Creating context

- (NSURL*)urlPathCurrentModel {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject URLByAppendingPathComponent:@"CDModel.cdmodel"];
}

- (void)createPSD {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CDModel" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    self.psd = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSError *error;
    NSURL *path = [self urlPathCurrentModel];
    NSLog(@"%@", path);
    [self.psd addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:path options:nil error:&error];
    
    NSAssert(error == nil, error.description);
}

- (NSManagedObjectContext*)createManagedObjectContext:(NSManagedObjectContextConcurrencyType)concurrencyType {
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    context.persistentStoreCoordinator = self.psd;
    
    return context;
}

#pragma mark - Class method

+ (NSArray*)fetchObjectInContext:(NSManagedObjectContext*)moc request:(NSFetchRequest*)request {
    NSError *error;
    NSArray *items = [moc executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", [error description]);
        return nil;
    }
    return items;
}


@end
