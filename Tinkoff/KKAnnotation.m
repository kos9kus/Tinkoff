//
//  KKAnnotation.m
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 29/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import "KKAnnotation.h"
#import "Item.h"

@implementation KKAnnotation

- (instancetype)initWithLocation:(CLLocationCoordinate2D)coord item:(Item*)item {
    self = [super init];
    if (self) {
        _item = item;
        _coordinate = coord;
        _subtitle = item.fullAddress;
        _title = item.partnerName;
    }
    return self;
}

@end
