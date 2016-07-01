//
//  KKPosition.m
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 28/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKPosition.h"

KKPosition KKPositionMake(double latitude, double longitude, int r) {
    KKPosition p;
    p.latitude = latitude;
    p.longitude = longitude;
    p.radius = r;
    return p;
}

#define deg2rad(degrees) ((M_PI * degrees)/180)

NSPredicate* createPredicateWIthRadius(KKPosition position) {
    float minLat = position.latitude - (position.radius / 69);
    float maxLat = position.latitude + (position.radius / 69);
    float minLon = position.latitude - position.radius / fabs(cos(deg2rad(position.latitude))*69);
    float maxLon = position.longitude + position.radius / fabs(cos(deg2rad(position.latitude))*69);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"latitude <= %f AND latitude >= %f AND longitude <= %f AND longitude >= %f", maxLat, minLat, maxLon, minLon];
    return predicate;
}


NSPredicate* createPredicateWIthRadius_2(KKPosition position) {
    double const D = position.radius;
    double const R = 6371009.; // Earth readius in meters
    double meanLatitidue = position.latitude * M_PI / 180.;
    double deltaLatitude = D / R * 180. / M_PI;
    double deltaLongitude = D / (R * cos(meanLatitidue)) * 180. / M_PI;
    double minLatitude = position.latitude - deltaLatitude;
    double maxLatitude = position.latitude + deltaLatitude;
    double minLongitude = position.longitude - deltaLongitude;
    double maxLongitude = position.longitude + deltaLongitude;
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(%@ <= longitude) AND (longitude <= %@)"
                              @"AND (%@ <= latitude) AND (latitude <= %@)",
                              @(minLongitude), @(maxLongitude), @(minLatitude), @(maxLatitude)];
    return predicate;
}
