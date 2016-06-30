//
//  KKOperationImage.h
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 29/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKAnnotationView;

typedef NS_ENUM(NSUInteger, KKOperationImageType) {
    KKOperationImageTypeMDPI,
    KKOperationImageTypeHDPI,
    KKOperationImageTypeXHDPI,
    KKOperationImageTypeXXHDPI
};

@interface KKOperationImage : NSOperation

- (id)initWithAnnotaion:(MKAnnotationView*)annotation imageFileName:(NSString*)imageFileName typeDpi:(KKOperationImageType)typeDpi;

@end
