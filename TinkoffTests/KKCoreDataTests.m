//
//  KKCoreDataTests.m
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 28/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KKCoreDataStack.h"
#import "Partner.h"
#import "Item.h"

@interface KKCoreDataTests : XCTestCase {
    KKCoreDataStack *ds;
    KKCoreDataStack *dsMain;
}

@end

@implementation KKCoreDataTests

- (void)setUp {
    [super setUp];
    ds = [[KKCoreDataStack alloc] init];
}

- (void)testPutPartnerToDB {
    Partner *partner = [Partner findOrCreatePartner:@"test" context:ds.cdBackGroundContext];
    partner.idItem = @"TestItem";
    partner.name = @"nameTest";
    XCTAssert(partner != nil);
    
    Partner *partner2 = [Partner findOrCreatePartner:@"TestItem" context:ds.cdBackGroundContext]; // Take from registredObcts
    
    
    Partner *partner3 = [Partner findOrCreatePartner:@"TestItem3" context:ds.cdBackGroundContext];
    partner3.idItem = @"TestItem3";
    
    NSLog(@"%@", ds.cdBackGroundContext.registeredObjects);
    XCTAssert([partner3.idItem isEqualToString:@"TestItem3"]);
    XCTAssert([partner2.name isEqualToString:partner.name]);
}

- (void)testPutPartnerViaDict {
    Partner *partner = [Partner mapPartnerDictionary:@{@"id": @"Kostya", @"isMomentary":@"0" } intoContext:ds.cdBackGroundContext];
    XCTAssert([partner.idItem isEqualToString:@"Kostya"]);
}

- (void)testPutItemVieDictionery {
    NSDictionary *dic = @{ @"externalId": @"M021", @"partnerName" : @"EUROSET" };
    Item *itemEntity = [Item mapFromDictionary:dic intoContext:ds.cdBackGroundContext];
    
    NSLog(@"%@", itemEntity.partner.descriptionItem);
    
    XCTAssert(itemEntity != nil);
}

- (void)testFetchItem {
    KKPosition position = KKPositionMake(55.755786, 37.617633, 1000);
    NSArray *items = [Item fetchEntitiesPartnerName:nil position:position context:ds.cdMainContext];
    Item *i = items.firstObject;
    NSLog(@"Picture: %@", i.partner.picture);
    
    XCTAssert(i.partner.picture);
}

@end
