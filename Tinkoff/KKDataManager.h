//
//  KKDataManager.h
//  Tinkoff
//
//  Created by KONSTANTIN KUSAINOV on 28/06/16.
//  Copyright © 2016 Kos9Kus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKPosition.h"

@class KKDataManager;

@protocol KKDataManagerDelegate <NSObject>

- (void)didFinishLoadDataManager:(KKDataManager*)dataManager;

@end

@interface KKDataManager : NSObject

@property (nonatomic, strong, readonly) NSArray* items;

@property (nonatomic, weak) id<KKDataManagerDelegate> delegate;

- (void)startLoading;
- (void)didChangePosition:(KKPosition)position;
- (void)didChangePosition:(KKPosition)position forPartner:(NSString*)partner;

@end
