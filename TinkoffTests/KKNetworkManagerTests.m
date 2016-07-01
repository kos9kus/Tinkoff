//
//  KKNetworkManagerTests.m
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 28/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KKNetworkManager.h"

@interface KKNetworkManagerTests : XCTestCase<KKNetworkManagerDelegate> {
    KKNetworkManager *m;
    XCTestExpectation *expectation;
}

@end

@implementation KKNetworkManagerTests

- (void)setUp {
    [super setUp];
    m = [KKNetworkManager new];
    m.delegate = self;
    expectation = [self expectationWithDescription:@"KKNetworkManagerTests"];
}

- (void)testMakeRequestGetAllPartners {
    [m makeRequestGetAllPartners];
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testMakeRequestWithPosition {
    [m makeRequestWithPosition:KKPositionMake(55.755786, 37.617633, 1000)];
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testMakeRequestWithPositionPartner {
    [m makeRequestWithPosition:KKPositionMake(55.755786, 37.617633, 1000) forPartner:@"EUROSET"];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

#pragma mark - 

- (void)didLoadItemsKKNetworkManager:(KKNetworkManager *)manager withArray:(NSDictionary *)items {
    NSArray *arrayItems = items[kKKNetworkManagerPayload];
    if (arrayItems.count > 0 && [items[kKKNetworkManagerResultCode] isEqualToString:@"OK"]) {
        [expectation fulfill];
    }
}

@end
