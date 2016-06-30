//
//  KKDataManager.m
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 28/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import "KKDataManager.h"
#import "KKCoreDataStack.h"
#import "KKNetworkManager.h"
#import "Partner.h"
#import "Item.h"


@interface KKDataManager()<KKNetworkManagerDelegate>

@property (nonatomic, strong) KKNetworkManager *netoworkManager;
@property (nonatomic, strong) KKCoreDataStack *cdStack;
@property (nonatomic) KKPosition currentPosition;
@property (nonatomic, strong) NSString *choosenPartner;

@end

@implementation KKDataManager

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cdStack = [[KKCoreDataStack alloc] init];
        
        self.netoworkManager = [[KKNetworkManager alloc] init];
        self.netoworkManager.delegate = self;
        
        [self initializeInstance];
    }
    return self;
}

- (void)initializeInstance {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:self.cdStack.cdBackGroundContext];
}

- (void)dealloc {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

#pragma mark - Public

- (void)didChangePosition:(KKPosition)position {
    [self didChangePosition:position forPartner:nil];
}

- (void)didChangePosition:(KKPosition)position forPartner:(NSString*)partner {
    self.currentPosition = position;
    self.choosenPartner = partner;
    
    [self startLoading];
}

- (void)startLoading {
    [self.netoworkManager resetTask];
    [self.netoworkManager makeRequestGetAllPartners];
}

#pragma mark - Private

- (void)fetchFromLocalStore {
    _items = [Item fetchEntitiesPartnerName:self.choosenPartner position:self.currentPosition context:self.cdStack.cdMainContext];
    
    if ([self.delegate respondsToSelector:@selector(didFinishLoadDataManager:)]) {
        [self.delegate didFinishLoadDataManager:self];
    }
}

- (void)contextDidSave:(NSNotification*)notification {
    [self.cdStack.cdMainContext performBlock:^{
        [self.cdStack.cdMainContext mergeChangesFromContextDidSaveNotification:notification];
        [self fetchFromLocalStore];
    }];
}


#pragma mark - KKNetworkManagerDelegate

- (void)didLoadItemsKKNetworkManager:(KKNetworkManager *)manager withArray:(NSDictionary *)items {
    if (manager == self.netoworkManager) {
        switch (manager.type) {
            case KKNetworkManagerTypePartners: {
                [self.cdStack resetBackGroundContext];
                NSArray *arrayItems = items[kKKNetworkManagerPayload];
                if (arrayItems.count > 0 && [items[kKKNetworkManagerResultCode] isEqualToString:@"OK"]) {
                    for (NSDictionary* item in arrayItems) {
                        [Partner mapPartnerDictionary:item intoContext:self.cdStack.cdBackGroundContext];
                    }
                    [self.netoworkManager makeRequestWithPosition:self.currentPosition];
                }
            }
                break;
            case KKNetworkManagerTypePoints: {
                NSArray *arrayItems = items[kKKNetworkManagerPayload];
                if (arrayItems.count > 0 && [items[kKKNetworkManagerResultCode] isEqualToString:@"OK"]) {
                    for (NSDictionary* item in arrayItems) {
                        [Item mapFromDictionary:item intoContext:self.cdStack.cdBackGroundContext];
                    }
                    [self.cdStack saveContext];
                }
            }
                break;
            default:
                break;
        }
    }
}

- (void)didFailedKKNetworkManager:(KKNetworkManager *)manager error:(NSError *)error {
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    [self.cdStack.cdMainContext performBlock:^{
        [self fetchFromLocalStore];
    }];
}


@end
