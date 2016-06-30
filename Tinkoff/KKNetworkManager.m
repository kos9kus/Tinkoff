//
//  KKNetworkManager.m
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 28/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import "KKNetworkManager.h"

#define KKNetworkManager_partnerUrl @"https://api.tinkoff.ru/v1/deposition_partners?accountType=Credit"
#define KKNetworkManager_deposition_points @"https://api.tinkoff.ru/v1/deposition_points?" //latitude=55.755786&longitude=37.617633&radius=1000"

@interface KKNetworkManager()

@property (nonatomic, strong) NSURLSessionTask *task;

@end

@implementation KKNetworkManager

#pragma mark - Public

- (void)makeRequestWithPosition:(KKPosition)position forPartner:(NSString*)partnerName {
    NSString *stringURL = [NSString stringWithFormat:@"%@latitude=%f&longitude=%f&partners=%@&radius=%i", KKNetworkManager_deposition_points, position.latitude, position.longitude, partnerName, position.radius];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
    _type = KKNetworkManagerTypePoints;
    [self executeRequest:request];
}

- (void)makeRequestWithPosition:(KKPosition)position {
    NSString *stringURL = [NSString stringWithFormat:@"%@latitude=%f&longitude=%f&radius=%i", KKNetworkManager_deposition_points, position.latitude, position.longitude, position.radius];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
    _type = KKNetworkManagerTypePoints;
    [self executeRequest:request];
}

- (void)makeRequestGetAllPartners {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:KKNetworkManager_partnerUrl]];
    _type = KKNetworkManagerTypePartners;
    [self executeRequest:request];
}

- (void)resetTask {
    if (self.task) {
        [self.task cancel];
    }
}

- (NSData*)makeSyncRequestRegardCacheWithUrl:(NSURL*)url {
    NSMutableURLRequest *request = [self createMutableCacheUrlRequestWithUrl:url];
    __block NSData *dataOut = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    self.task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.description);
        }
        if (data.length > 0) {
            dataOut = data;
        } else {
            NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
            dataOut = cachedResponse.data;
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [self.task resume];
    
    dispatch_time_t waitTime = dispatch_time( DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)); // timeout is 10 sec
    dispatch_semaphore_wait(semaphore, waitTime);
    return dataOut;
}

#pragma mark - Private

- (void)executeRequest:(NSURLRequest*)request {
    NSLog(@"Executing request: %@", request);
    
    self.task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            [self executeRespondData:data];
        } else {
            NSLog(@"%@", error.description);
            if ([self.delegate respondsToSelector:@selector(didFailedKKNetworkManager:error:)]) {
                [self.delegate didFailedKKNetworkManager:self error:error];
            }
        }
    }];
    [self.task resume];
}

- (void)executeRespondData:(NSData*)data {
    NSError* err = nil;
    NSDictionary* items = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers
                                                       error:&err];
//    NSLog(@"Imported Banks: %@", items);
    if (!err) {
        if ([self.delegate respondsToSelector:@selector(didLoadItemsKKNetworkManager:withArray:)]) {
            [self.delegate didLoadItemsKKNetworkManager:self withArray:items];
        }
    } else {
        NSLog(@"%@", err.description);
    }
}

- (NSMutableURLRequest*)createMutableCacheUrlRequestWithUrl:(NSURL*)url {
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:500];
    
    NSURLCache* cache = [NSURLCache sharedURLCache];
    NSCachedURLResponse* cachedResponse = [cache cachedResponseForRequest:request];
    NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse*)[cachedResponse response];
    
    NSString* lastModified = [[urlResponse allHeaderFields] objectForKey:@"Last-Modified"];
    if ( lastModified != nil ) {
        [request setValue:lastModified forHTTPHeaderField:@"If-Modified-Since"];
        // prefer server modification handling over local caching
        request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    }
    
    NSString* etag = [[urlResponse allHeaderFields] objectForKey:@"ETag"];
    if ( etag != nil ) {
        [request setValue:etag forHTTPHeaderField:@"If-None-Match"];
        // prefer server modification handling over local caching
        request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    }
    
    return request;
}

@end
