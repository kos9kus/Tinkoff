//
//  KKAnnotation.h
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 29/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@class Item;

@interface KKAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;
@property (nonatomic, readonly, nonnull) Item *item;

- (instancetype _Nonnull)initWithLocation:(CLLocationCoordinate2D)coord item:(Item* _Nonnull)item;

@end
