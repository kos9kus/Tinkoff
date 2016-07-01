//
//  KKPosition.h
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 28/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    double longitude;
    double latitude;
    int radius;
} KKPosition;

KKPosition KKPositionMake(double latitude, double longitude, int r);
NSPredicate* createPredicateWIthRadius(KKPosition position);
NSPredicate* createPredicateWIthRadius_2(KKPosition position);