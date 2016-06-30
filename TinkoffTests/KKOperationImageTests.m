//
//  KKOperationImageTests.m
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 29/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KKOperationImage.h"
@import MapKit;

@interface KKOperationImageTests : XCTestCase {
    XCTestExpectation *expectation;
}
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation KKOperationImageTests

- (void)setUp {
    [super setUp];
    self.queue = [[NSOperationQueue alloc] init];
    expectation = [self expectationWithDescription:@"KKOperationImageTests"];
}

- (void)testAddOperatioin {
    MKAnnotationView *a = [[MKAnnotationView alloc] init];
    [self.queue cancelAllOperations];
    KKOperationImage *operation = [[KKOperationImage alloc] initWithAnnotaion:a imageFileName:@"contact.png" typeDpi:KKOperationImageTypeXHDPI];
    [self.queue addOperation:operation];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail("expectation failed");
        }
    }];
    
    
}

@end
