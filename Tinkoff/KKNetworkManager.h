//
//  KKNetworkManager.h
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 28/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKPosition.h"

#define kKKNetworkManagerPayload @"payload"
#define kKKNetworkManagerResultCode @"resultCode"

typedef NS_ENUM(NSUInteger, KKNetworkManagerType) {
    KKNetworkManagerTypePoints,
    KKNetworkManagerTypePartners
};

@class KKNetworkManager;

@protocol KKNetworkManagerDelegate <NSObject>

- (void)didLoadItemsKKNetworkManager:(KKNetworkManager*)manager withArray:(NSDictionary*)items;

@optional
- (void)didFailedKKNetworkManager:(KKNetworkManager*)manager error:(NSError*)error;

@end


@interface KKNetworkManager : NSObject

@property (nonatomic, weak) id<KKNetworkManagerDelegate>delegate;
@property (nonatomic, readonly) KKNetworkManagerType type;

- (void)makeRequestWithPosition:(KKPosition)position forPartner:(NSString*)partnerName;
- (void)makeRequestWithPosition:(KKPosition)position;
- (void)makeRequestGetAllPartners;

- (NSData*)makeSyncRequestRegardCacheWithUrl:(NSURL*)url;

- (void)resetTask;

@end
